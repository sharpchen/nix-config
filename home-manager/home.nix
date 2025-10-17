{
  config,
  pkgs,
  stable,
  lib,
  ...
}:
{
  imports = [
    ../packages/default.nix
  ];

  options = {
    dotfiles = lib.mkOption {
      type = lib.types.path;
      apply = toString;
      default = "${config.home.homeDirectory}/.config/home-manager/dotfiles";
      example = "${config.home.homeDirectory}/.config/home-manager/dotfiles";
      description = "Location of the dotfiles working copy";
    };
  };

  config = {
    nix = {
      package = pkgs.nixVersions.latest;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };

    home = rec {
      username = "sharpchen";
      homeDirectory = "/home/${username}";
      stateVersion = "24.05"; # Please read the comment before changing.
    };

    home.sessionPath = [
      "$HOME/.local/bin/"
    ];

    targets.genericLinux.enable = true;

    programs.home-manager.enable = true;

    xdg.enable = true;
  };
}
