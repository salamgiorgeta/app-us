import next from "eslint-config-next";
import eslintConfigPrettier from "eslint-config-prettier";

export default [
  ...next,
  eslintConfigPrettier, // <- ultimul
];
