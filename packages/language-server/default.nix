{ pkgs, ... }:
{
  home.packages = with pkgs;[
    roslyn-ls
    lua-language-server
    taplo
    nixd
    lemminx 
    actionlint
    ast-grep
    emmet-language-server
    nodePackages.bash-language-server
    # nodePackages.vscode-html-languageservice
    # nodePackages.vscode-json-languageservice
    fsautocomplete
    quick-lint-js
    markdownlint-cli2
    typescript-language-server
  ];
  
}
