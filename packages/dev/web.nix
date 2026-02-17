{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_22
    biome
    pnpm
    quick-lint-js
    emmet-language-server
    vtsls
    typescript-go
    vue-language-server
    vscode-langservers-extracted
    vscode-js-debug
  ];

  home.file.".npmrc" = {
    text = # ini
      ''
        registry=https://registry.npmmirror.com
      '';
  };
}
