import js from "@eslint/js";
import globals from "globals";
import { defineConfig } from "eslint/config";

export default defineConfig([
  {
    files: ["**/*.mjs}"],
    plugins: { js },
    extends: ["js/recommended"],
    languageOptions: {
      ecmaVersion: "lateset",
    },
  },
  {
    files: ["**/*.js"],
    languageOptions: {
      globals: globals.commonjs,
      ecmaVersion: 5,
      sourceType: "commonjs",
    },
  },
]);
