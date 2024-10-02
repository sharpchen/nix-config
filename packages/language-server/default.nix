{ pkgs, ... }:
{
  home.packages = with pkgs;[
    roslyn-ls
    lua-language-server
    taplo
    biome
    # nodePackages."@vtsls/language-server"
    nixd
    lemminx 
    actionlint
    ast-grep
    emmet-language-server
    nodePackages.bash-language-server
    # nodePackages.vscode-html-languageservice
    # nodePackages.vscode-json-languageservice
    fsautocomplete
    markdownlint-cli2
    (import ./vtsls.nix { pkgs = pkgs; })
  ];
  
}
