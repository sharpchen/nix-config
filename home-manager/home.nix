{
  config,
  pkgs,
  stable,
  lib,
  flakeinputs,
  ...
}:
{
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
      # The option `home-manager.users.sharpchen.nix.package' is defined multiple times while it's expected to be unique.
      # package = pkgs.nixVersions.latest;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
      nixPath = [ "nixpkgs=${flakeinputs.nixpkgs}" ];
    };

    home = rec {
      username = "sharpchen";
      homeDirectory = "/home/${username}";
      stateVersion = "26.05"; # Please read the comment before changing.
    };

    home.sessionPath = [
      "$HOME/.local/bin/"
    ];

    targets.genericLinux.enable = true;

    programs.home-manager.enable = true;

    xdg.enable = true;
  };
}
