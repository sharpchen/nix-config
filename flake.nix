{
  description = "Home Manager configuration of sharpchen";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    unstablePkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    stablePkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "unstablePkgs";
    };
  };

  outputs =
    {
      stablePkgs,
      unstablePkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = unstablePkgs.legacyPackages.${system};
      stable = stablePkgs.legacyPackages.${system};
      allowUnfree = {
        nixpkgs.config.allowUnfree = true;
      };
    in
    {
      homeConfigurations."sharpchen" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          allowUnfree
        ];
        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { inherit stable; };
      };
    };
}
