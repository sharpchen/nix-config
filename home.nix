{
  config,
  pkgs,
  stable,
  ...
}:
{
  nix = {
    package = pkgs.nixVersions.latest;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
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
