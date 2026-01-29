#!/usr/bin/env node
/**
 * Adds .js extensions to relative imports in generated TypeScript files
 * so they work with NodeNext/Node16 moduleResolution.
 */
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const generatedDir = path.join(__dirname, "..", "src", "generated");

function fixFile(filePath) {
  let content = fs.readFileSync(filePath, "utf8");
  // Match relative imports: from './...' or from '../...' (no .js yet)
  content = content.replace(
    /from\s+['"](\.\.[\/\w-]*|\.\/[\/\w-]*)['"]\s*;?/g,
    (match) => {
      const pathPart = match.replace(/from\s+['"]|['"]\s*;?/g, "").trim();
      if (pathPart.endsWith(".js")) return match;
      return match.replace(pathPart, pathPart + ".js");
    }
  );
  fs.writeFileSync(filePath, content);
}

function walk(dir) {
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    if (fs.statSync(full).isDirectory()) walk(full);
    else if (name.endsWith(".ts")) fixFile(full);
  }
}

walk(generatedDir);
console.log("Fixed .js extensions in generated imports.");
