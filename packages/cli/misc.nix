{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    lua5_1
    rustc
    cargo
    wget
    openssh
    tree-sitter
    ripgrep
    csharprepl
    rainfrog
    which
    bat
    tokei
    fzf
    fd
    mpv
    glow
    jq
    ffmpeg
    nix-prefetch
    nix-prefetch-github
    evil-helix
    sioyek
    postgresql
    zoxide
    devenv
    gdu
    # dict
    # dictdDBs.wiktionary
    nh
    tree
    tlrc
    sqlite
    ollama
    file
    nurl
    nix-init
    btop
    yt-dlp
    glib
    dig
    ocrmypdf
    tesseract # NOTE: dependency of ocrmypdf
    tty-clock
    qpdf
    tocpdf
    libarchive
    _7zz-rar
    hyperfine
  ];
  # home.file.".dict/.dict.conf".text = ''
  #   server localhost
  # '';
  # home.file.".dict/dictd.conf".text = ''
  #   global {
  #       pid_file ${config.home.homeDirectory}/.dict/.dictd.pid
  #   }
  #   database wiktionary {
  #       data ${pkgs.dictdDBs.wiktionary}/share/wiktionary-en.dict.dz
  #       index ${pkgs.dictdDBs.wiktionary}/share/wiktionary-en.index
  #   }
  # '';
  # home.file.".dict/.dictd.pid".text = "";

  home.file.".config/helix/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/helix.config.toml";

  home.file.".ssh/config".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/sshconfig";
  home.file.".fzfrc".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/.fzfrc";
}
