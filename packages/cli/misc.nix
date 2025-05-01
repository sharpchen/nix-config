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
    fd
    ouch
    miller
    transmission_4
    imagemagick
    mpv
    glow
    jq
    ffmpeg
    poppler
    nix-prefetch
    nix-prefetch-github
    helix
    viu
    just
    wordnet
    sioyek
    postgresql
    zoxide
    devenv
    ncdu
  ];

  home.file.".config/lazygit/config.yml".source = ../../dotfiles/lazygit.config.yml;
  home.file.".config/yazi/yazi.toml".source = ../../dotfiles/yazi.toml;
  home.file.".config/yazi/keymap.toml".source = ../../dotfiles/yazi.keymap.toml;
  home.file.".config/helix/config.toml".source = ../../dotfiles/helix.config.toml;

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
  };
}
