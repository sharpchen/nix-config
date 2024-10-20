{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wget
    openssh
    gzip
    tree-sitter
    cargo
    rustc
    fd
    cmake
    gnumake
    lua5_1
    lazygit
    tokei
    bat
    ripgrep
    gcc
    unzip
    csharprepl
  ];

  home.file.".config/lazygit/config.yml".source = ../../dotfiles/lazygit.config.yml;
}
