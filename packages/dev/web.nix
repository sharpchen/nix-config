{ pkgs, ... }:
{
  home.packages = with pkgs;[
    nodejs_22
    nodePackages.prettier
    pnpm
    quick-lint-js
    emmet-language-server
    typescript-language-server 
    vue-language-server
    vscode-langservers-extracted
  ];

  home.file.".prettierrc".text = /* json */
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
    text = /* ini */''
      registry=https://registry.npmmirror.com
    '';
  };
}
