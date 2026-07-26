import { access, readFile, stat } from "node:fs/promises";
import path from "node:path";
import process from "node:process";
import { fileURLToPath } from "node:url";

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(scriptDir, "..");
const distDir = path.join(repoRoot, "dist");

async function requireFile(relativePath) {
  const absolutePath = path.join(distDir, relativePath);
  await access(absolutePath);
  const info = await stat(absolutePath);
  if (!info.isFile() || info.size === 0) {
    throw new Error(`missing or empty generated file: ${relativePath}`);
  }
  return absolutePath;
}

async function main() {
  const indexPath = await requireFile("index.html");
  await requireFile("game.js");
  await requireFile("game.data");
  await requireFile("love.js");
  await requireFile("love.wasm");
  await requireFile("theme/love.css");
  await requireFile("theme/bg.png");

  const index = await readFile(indexPath, "utf8");
  if (!index.includes("var Module = {")) {
    throw new Error("generated index.html does not declare the shared love.js Module variable");
  }
  if (/\b(?:const|let)\s+Module\b/.test(index)) {
    throw new Error("generated index.html redeclares Module with const/let and will break game.js");
  }
  if (!index.includes('src="game.js"') || !index.includes('src="love.js"')) {
    throw new Error("generated index.html is missing the love.js loader scripts");
  }
  if (!index.includes('href="theme/love.css"')) {
    throw new Error("generated index.html is missing the original love.js theme");
  }

  console.log("verified love.js page: shared Module, game archive loader, and original theme are present");
}

main().catch((error) => {
  console.error(`love.js page verification failed: ${error.stack || error.message}`);
  process.exitCode = 1;
});
