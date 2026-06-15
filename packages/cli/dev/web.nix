{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    nodejs_22
    oxlint
    oxfmt
    pnpm
    quick-lint-js
    emmet-language-server
    vtsls
    typescript-go
    vue-language-server
    vscode-langservers-extracted
    vscode-js-debug
  ];

  home.file.".npmrc".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/.npmrc";
}
