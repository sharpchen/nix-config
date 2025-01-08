{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_22
    nodePackages.ts-node
    nodePackages.prettier
    pnpm
    quick-lint-js
    emmet-language-server
    typescript-language-server
    vtsls
    vue-language-server
    vscode-langservers-extracted
    vscode-js-debug
  ];

  home.file.".prettierrc".text = # json
    ''
      {
        "singleQuote": true,
        "tabWidth": 2,
        "semi": true,
        "htmlWhitespaceSensitivity": "ignore",
        "vueIndentScriptAndStyle": true,
        "arrowParens": "avoid",
        "printWidth": 100,
        "trailingComma": "all"
      }
    '';

  home.file.".npmrc" = {
    text = # ini
      ''
        registry=https://registry.npmmirror.com
      '';
  };
}
