{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
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
    imagemagick
    mpv
    glow
    jq
    ffmpeg
    poppler
    nix-prefetch
    nix-prefetch-github
    evil-helix
    viu
    sioyek
    postgresql
    zoxide
    devenv
    ncdu
    dict
    dictdDBs.wiktionary
    nh
    tree
    tlrc
    sqlite
    ollama
    file
    nurl
    nix-init
  ];
  home.file.".dict/.dict.conf".text = ''
    server localhost
  '';
  home.file.".dict/dictd.conf".text = ''
    global {
        pid_file ${config.home.homeDirectory}/.dict/.dictd.pid
    }
    database wiktionary {
        data ${pkgs.dictdDBs.wiktionary}/share/wiktionary-en.dict.dz
        index ${pkgs.dictdDBs.wiktionary}/share/wiktionary-en.index
    }
  '';
  home.file.".dict/.dictd.pid".text = "";

  home.file.".config/lazygit/config.yml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/lazygit.config.yml";
  home.file.".config/yazi/yazi.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/yazi.toml";
  home.file.".config/yazi/keymap.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/yazi.keymap.toml";
  home.file.".config/helix/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/helix.config.toml";

  home.file.".ssh/config".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/sshconfig";
  home.file.".fzfrc".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/.fzfrc";

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
  };
}
