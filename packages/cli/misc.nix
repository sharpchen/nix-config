{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc
    cmake
    gnumake
    lua5_1
    rustc
    cargo
    wget
    openssh
    lazygit
    tree-sitter
    ripgrep
    gzip
    unzip
    csharprepl
    rainfrog
    which
    bat
    tokei
    fzf
    yazi
    fd ouch miller transmission_4 imagemagick mpv glow jq ffmpeg poppler
  ];

  home.file.".config/lazygit/config.yml".source = ../../dotfiles/lazygit.config.yml;
}
