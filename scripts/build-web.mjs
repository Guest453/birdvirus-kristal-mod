import { createWriteStream } from "node:fs";
import {
  access,
  cp,
  mkdir,
  readFile,
  rm,
  stat,
  writeFile,
} from "node:fs/promises";
import { spawn } from "node:child_process";
import path from "node:path";
import process from "node:process";
import { fileURLToPath } from "node:url";
import archiver from "archiver";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(__dirname, "..");
const buildRoot = path.join(repoRoot, ".build");
const kristalDir = path.join(buildRoot, "kristal");
const lovePath = path.join(buildRoot, "birdvirus-kristal-web.love");
const distDir = path.join(repoRoot, "dist");
const title = process.env.WEB_TITLE || "Birdvirus — Kristal Web";
const kristalRepository = process.env.KRISTAL_REPOSITORY || "https://github.com/KristalTeam/Kristal.git";
const kristalRef = process.env.KRISTAL_REF || "main";
const requestedSource = process.env.KRISTAL_SOURCE_DIR;

const modEntries = [
  "mod.json",
  "mod.lua",
  "assets",
  "scripts",
  "libraries",
  "preview",
  "LICENSE",
  "license",
  "THIRD_PARTY_LICENSES",
];

async function exists(target) {
  try {
    await access(target);
    return true;
  } catch {
    return false;
  }
}

function run(command, args, options = {}) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      cwd: options.cwd || repoRoot,
      env: { ...process.env, ...options.env },
      stdio: "inherit",
      shell: false,
    });

    child.on("error", reject);
    child.on("exit", (code, signal) => {
      if (code === 0) {
        resolve();
        return;
      }
      reject(new Error(`${command} failed with code ${code ?? "null"}${signal ? ` (${signal})` : ""}`));
    });
  });
}

async function cloneKristal() {
  if (requestedSource) {
    const source = path.resolve(requestedSource);
    if (!(await exists(path.join(source, "main.lua")))) {
      throw new Error(`KRISTAL_SOURCE_DIR does not contain main.lua: ${source}`);
    }
    console.log(`using kristal source from ${source}`);
    await cp(source, kristalDir, { recursive: true, force: true });
    return;
  }

  console.log(`cloning kristal (${kristalRef}) from ${kristalRepository}`);
  await run("git", [
    "clone",
    "--depth",
    "1",
    "--branch",
    kristalRef,
    kristalRepository,
    kristalDir,
  ]);
}

async function readModMetadata() {
  const modJsonPath = path.join(repoRoot, "mod.json");
  if (!(await exists(modJsonPath))) {
    throw new Error("mod.json is missing from the repository root");
  }

  let metadata;
  try {
    metadata = JSON.parse(await readFile(modJsonPath, "utf8"));
  } catch (error) {
    throw new Error(`mod.json is not valid json: ${error.message}`);
  }

  if (!metadata.id || typeof metadata.id !== "string") {
    throw new Error("mod.json must contain a string id");
  }
  return metadata;
}

async function copyMod(modId) {
  const target = path.join(kristalDir, "mods", modId);
  await rm(target, { recursive: true, force: true });
  await mkdir(target, { recursive: true });

  let copied = 0;
  for (const entry of modEntries) {
    const source = path.join(repoRoot, entry);
    if (!(await exists(source))) continue;
    await cp(source, path.join(target, entry), {
      recursive: true,
      force: true,
      errorOnExist: false,
    });
    copied += 1;
  }

  if (!(await exists(path.join(target, "mod.json")))) {
    throw new Error("the bundled project is missing mod.json after copying");
  }
  if (copied < 2) {
    throw new Error("not enough project files were copied into kristal");
  }
  console.log(`bundled project ${modId} into kristal`);
}

function replaceRequired(source, pattern, replacement, label) {
  if (!pattern.test(source)) {
    throw new Error(`could not patch ${label}; kristal source layout may have changed`);
  }
  return source.replace(pattern, replacement);
}

async function patchKristal(modId) {
  const vendcustPath = path.join(kristalDir, "src", "engine", "vendcust.lua");
  let vendcust = await readFile(vendcustPath, "utf8");
  vendcust = replaceRequired(
    vendcust,
    /^TARGET_MOD\s*=\s*nil\s*$/m,
    `TARGET_MOD = ${JSON.stringify(modId)}`,
    "TARGET_MOD in vendcust.lua",
  );
  vendcust = replaceRequired(
    vendcust,
    /^AUTO_MOD_START\s*=\s*false\s*$/m,
    "AUTO_MOD_START = true",
    "AUTO_MOD_START in vendcust.lua",
  );
  vendcust = replaceRequired(
    vendcust,
    /^RELEASE_MODE\s*=\s*false\s*$/m,
    "RELEASE_MODE = true",
    "RELEASE_MODE in vendcust.lua",
  );
  await writeFile(vendcustPath, vendcust);

  const confPath = path.join(kristalDir, "conf.lua");
  let conf = await readFile(confPath, "utf8");
  conf = replaceRequired(
    conf,
    /t\.identity\s*=\s*["'][^"']+["']/,
    't.identity = "birdvirus_kristal_web"',
    "identity in conf.lua",
  );
  conf = replaceRequired(
    conf,
    /t\.window\.title\s*=\s*["'][^"']+["']/,
    `t.window.title = ${JSON.stringify(title)}`,
    "window title in conf.lua",
  );
  await writeFile(confPath, conf);
}

async function packageLove() {
  await mkdir(path.dirname(lovePath), { recursive: true });
  await rm(lovePath, { force: true });

  await new Promise((resolve, reject) => {
    const output = createWriteStream(lovePath);
    const archive = archiver("zip", { zlib: { level: 9 } });

    output.on("close", resolve);
    output.on("error", reject);
    archive.on("warning", (error) => {
      if (error.code === "ENOENT") console.warn(error.message);
      else reject(error);
    });
    archive.on("error", reject);
    archive.pipe(output);
    archive.glob("**/*", {
      cwd: kristalDir,
      dot: true,
      ignore: [".git/**", ".github/**"],
    });
    archive.finalize();
  });

  const info = await stat(lovePath);
  if (info.size === 0) throw new Error("generated .love archive is empty");
  console.log(`created ${path.relative(repoRoot, lovePath)} (${info.size} bytes)`);
  return info.size;
}

function calculateMemory(archiveSize) {
  const minimum = 512 * 1024 * 1024;
  const headroom = 192 * 1024 * 1024;
  const alignment = 64 * 1024;
  return Math.ceil(Math.max(minimum, archiveSize + headroom) / alignment) * alignment;
}

async function runLoveJs(memory) {
  await rm(distDir, { recursive: true, force: true });
  await mkdir(distDir, { recursive: true });

  const npx = process.platform === "win32" ? "npx.cmd" : "npx";
  await run(npx, [
    "--no-install",
    "love.js",
    "-c",
    "-t",
    title,
    "-m",
    String(memory),
    lovePath,
    distDir,
  ]);
}

async function installLauncher(metadata, memory) {
  const templatePath = path.join(repoRoot, "web", "index.template.html");
  let html = await readFile(templatePath, "utf8");
  html = html
    .replaceAll("__TITLE__", escapeHtml(title))
    .replaceAll("__MOD_NAME__", escapeHtml(metadata.name || metadata.id))
    .replaceAll("__MOD_ID__", escapeHtml(metadata.id))
    .replaceAll("__INITIAL_MEMORY__", String(memory));

  await writeFile(path.join(distDir, "index.html"), html);
  await cp(path.join(repoRoot, "web", "style.css"), path.join(distDir, "style.css"), { force: true });
  await writeFile(path.join(distDir, ".nojekyll"), "");
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

async function verifyBuild() {
  const required = [
    "index.html",
    "style.css",
    "game.js",
    "game.data",
    "love.js",
    "love.wasm",
  ];

  for (const file of required) {
    const filePath = path.join(distDir, file);
    if (!(await exists(filePath))) throw new Error(`web build is missing ${file}`);
    if ((await stat(filePath)).size === 0) {
      throw new Error(`web build produced an empty ${file}`);
    }
  }

  const gameDataSize = (await stat(path.join(distDir, "game.data"))).size;
  console.log(`verified dist/; game.data is ${gameDataSize} bytes`);
}

async function main() {
  console.log("building birdvirus for the browser");
  await rm(buildRoot, { recursive: true, force: true });
  await mkdir(buildRoot, { recursive: true });

  const metadata = await readModMetadata();
  await cloneKristal();
  await copyMod(metadata.id);
  await patchKristal(metadata.id);
  const archiveSize = await packageLove();
  const memory = calculateMemory(archiveSize);
  console.log(`love.js initial memory: ${memory} bytes`);
  await runLoveJs(memory);
  await installLauncher(metadata, memory);
  await verifyBuild();
  console.log("kristal web build complete: dist/index.html");
}

main().catch((error) => {
  console.error(`build failed: ${error.stack || error.message}`);
  process.exitCode = 1;
});
