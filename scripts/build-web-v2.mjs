import { createWriteStream } from "node:fs";
import { access, cp, mkdir, readFile, rm, stat, writeFile } from "node:fs/promises";
import { spawn } from "node:child_process";
import path from "node:path";
import process from "node:process";
import { fileURLToPath } from "node:url";
import archiver from "archiver";

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(scriptDir, "..");
const buildRoot = path.join(repoRoot, ".build");
const kristalDir = path.join(buildRoot, "kristal");
const lovePath = path.join(buildRoot, "birdvirus-kristal-web.love");
const distDir = path.join(repoRoot, "dist");
const title = process.env.WEB_TITLE || "Birdvirus — Kristal Web";
const kristalRepository = process.env.KRISTAL_REPOSITORY || "https://github.com/KristalTeam/Kristal.git";
const kristalRef = process.env.KRISTAL_REF || "main";
const requestedSource = process.env.KRISTAL_SOURCE_DIR;

const modEntries = [
  "mod.json", "mod.lua", "assets", "scripts", "libraries", "preview",
  "LICENSE", "license", "THIRD_PARTY_LICENSES",
];

async function exists(target) {
  try { await access(target); return true; } catch { return false; }
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
      if (code === 0) resolve();
      else reject(new Error(`${command} failed with code ${code ?? "null"}${signal ? ` (${signal})` : ""}`));
    });
  });
}

async function cloneKristal() {
  if (requestedSource) {
    const source = path.resolve(requestedSource);
    if (!(await exists(path.join(source, "main.lua")))) {
      throw new Error(`KRISTAL_SOURCE_DIR does not contain main.lua: ${source}`);
    }
    await cp(source, kristalDir, { recursive: true, force: true });
    return;
  }
  await run("git", ["clone", "--depth", "1", "--branch", kristalRef, kristalRepository, kristalDir]);
}

async function readModMetadata() {
  const modPath = path.join(repoRoot, "mod.json");
  const metadata = JSON.parse(await readFile(modPath, "utf8"));
  if (!metadata.id || typeof metadata.id !== "string") throw new Error("mod.json must contain a string id");
  return metadata;
}

async function copyMod(modId) {
  const target = path.join(kristalDir, "mods", modId);
  await rm(target, { recursive: true, force: true });
  await mkdir(target, { recursive: true });
  for (const entry of modEntries) {
    const source = path.join(repoRoot, entry);
    if (await exists(source)) await cp(source, path.join(target, entry), { recursive: true, force: true });
  }
  if (!(await exists(path.join(target, "mod.json")))) throw new Error("bundled mod is missing mod.json");
}

function replaceRequired(source, pattern, replacement, label) {
  if (!pattern.test(source)) throw new Error(`could not patch ${label}; upstream kristal changed`);
  return source.replace(pattern, replacement);
}

async function patchKristal(modId) {
  const vendcustPath = path.join(kristalDir, "src", "engine", "vendcust.lua");
  let vendcust = await readFile(vendcustPath, "utf8");
  vendcust = replaceRequired(vendcust, /^TARGET_MOD\s*=\s*nil\s*$/m, `TARGET_MOD = ${JSON.stringify(modId)}`, "TARGET_MOD");
  vendcust = replaceRequired(vendcust, /^AUTO_MOD_START\s*=\s*false\s*$/m, "AUTO_MOD_START = true", "AUTO_MOD_START");
  vendcust = replaceRequired(vendcust, /^RELEASE_MODE\s*=\s*false\s*$/m, "RELEASE_MODE = true", "RELEASE_MODE");
  await writeFile(vendcustPath, vendcust);

  const confPath = path.join(kristalDir, "conf.lua");
  let conf = await readFile(confPath, "utf8");
  conf = replaceRequired(conf, /t\.identity\s*=\s*["'][^"']+["']/, 't.identity = "birdvirus_kristal_web"', "identity");
  conf = replaceRequired(conf, /t\.window\.title\s*=\s*["'][^"']+["']/, `t.window.title = ${JSON.stringify(title)}`, "window title");
  conf = replaceRequired(conf, /t\.version\s*=\s*["']11\.5["']/, 't.version = "11.4"', "web love version");
  await writeFile(confPath, conf);

  const discordStub = `-- Browser build: native Discord RPC requires LuaJIT FFI and a desktop shared library.\nDISCORD_RPC_AVAILABLE = false\nDISCORD_RPC_INFO = "Disabled in the browser build"\nlocal noop = function() end\nreturn {\n    initialize = noop,\n    shutdown = noop,\n    runCallbacks = noop,\n    updatePresence = noop,\n    clearPresence = noop,\n    respond = noop,\n    updateHandlers = noop\n}\n`;
  await writeFile(path.join(kristalDir, "src", "lib", "discordrpc.lua"), discordStub);

  const httpsStub = `-- Browser build: Kristal's desktop HTTPS module requires LuaJIT FFI/native code.\nHTTPS_AVAILABLE = false\nHTTPS_INFO = "Disabled in the browser build"\nreturn {}\n`;
  await writeFile(path.join(kristalDir, "src", "lib", "https.lua"), httpsStub);
}

async function packageLove() {
  await mkdir(path.dirname(lovePath), { recursive: true });
  await rm(lovePath, { force: true });
  await new Promise((resolve, reject) => {
    const output = createWriteStream(lovePath);
    const archive = archiver("zip", { zlib: { level: 9 } });
    output.on("close", resolve);
    output.on("error", reject);
    archive.on("warning", (error) => error.code === "ENOENT" ? console.warn(error.message) : reject(error));
    archive.on("error", reject);
    archive.pipe(output);
    archive.glob("**/*", { cwd: kristalDir, dot: true, ignore: [".git/**", ".github/**"] });
    archive.finalize();
  });
  const info = await stat(lovePath);
  if (!info.size) throw new Error("generated .love archive is empty");
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
  await run(npx, ["--no-install", "love.js", "-c", "-t", title, "-m", String(memory), lovePath, distDir]);
}

async function installPage(memory) {
  let html = await readFile(path.join(repoRoot, "web", "index.template.html"), "utf8");
  html = html.replaceAll("__TITLE__", title).replaceAll("__INITIAL_MEMORY__", String(memory));
  await writeFile(path.join(distDir, "index.html"), html);
  await writeFile(path.join(distDir, ".nojekyll"), "");
}

async function verifyBuild() {
  for (const file of ["index.html", "game.js", "game.data", "love.js", "love.wasm", "theme/love.css", "theme/bg.png"]) {
    const target = path.join(distDir, file);
    if (!(await exists(target)) || !(await stat(target)).size) throw new Error(`missing generated file: ${file}`);
  }
  const index = await readFile(path.join(distDir, "index.html"), "utf8");
  if (!index.includes("var Module = {") || /\b(?:const|let)\s+Module\b/.test(index)) throw new Error("invalid Module declaration");
  const archive = await readFile(lovePath);
  if (!archive.length) throw new Error("empty love archive");
  const discord = await readFile(path.join(kristalDir, "src", "lib", "discordrpc.lua"), "utf8");
  const https = await readFile(path.join(kristalDir, "src", "lib", "https.lua"), "utf8");
  if (/require\s*["']ffi["']/.test(discord + https)) throw new Error("browser build still contains startup ffi requirements");
}

async function main() {
  console.log("building browser-compatible kristal");
  await rm(buildRoot, { recursive: true, force: true });
  await mkdir(buildRoot, { recursive: true });
  const metadata = await readModMetadata();
  await cloneKristal();
  await copyMod(metadata.id);
  await patchKristal(metadata.id);
  const archiveSize = await packageLove();
  const memory = calculateMemory(archiveSize);
  await runLoveJs(memory);
  await installPage(memory);
  await verifyBuild();
  console.log(`browser build complete: ${path.join(distDir, "index.html")}`);
}

main().catch((error) => {
  console.error(error.stack || error.message);
  process.exitCode = 1;
});
