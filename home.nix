{
  config,
  pkgs,
  stable,
  ...
}:
{
  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"
      ];
      # substituters = pkgs.lib.mkBefore [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };
  imports = [
    ./packages/default.nix
  ];
  home = rec {
    username = "sharpchen";
    homeDirectory = "/home/${username}";
    stateVersion = "24.05"; # Please read the comment before changing.
  };

  home.sessionPath = [
    "$HOME/.local/bin/"
  ];

  # home.sessionVariables = {
  #   # systemd.user.sessionVariables = {
  #   EDITOR = "nvim --clean -c \"source ~/.vimrc\"";
  #   XDG_RUNTIME_DIR = "$HOME/.cache/";
  # };

  targets.genericLinux.enable = true;

  programs.home-manager.enable = true;

  xdg.enable = true;
}
