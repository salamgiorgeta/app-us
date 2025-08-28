/** @type {import('eslint').Linter.Config} */
module.exports = {
  root: true,
  parser: "@typescript-eslint/parser",
  plugins: ["@typescript-eslint"],
  extends: [
    "next",
    "next/core-web-vitals",
    "plugin:@typescript-eslint/recommended",
    "prettier", // acesta TREBUIE să fie ULTIMUL
  ],
  overrides: [
    {
      files: ["next-env.d.ts", "**/*.d.ts"],
      rules: { "@typescript-eslint/triple-slash-reference": "off" },
    },
  ],
};
