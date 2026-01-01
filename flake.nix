{
  description = "Home Manager configuration of sharpchen";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      stable,
      nixpkgs,
      home-manager,
      nixos-wsl,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      stable = stable.legacyPackages.${system};
      allowUnfree = {
        nixpkgs.config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            flakeinputs = inputs;
          };
          modules = [
            ./nixos/configuration.nix
            ./nixos/nixos.nix
          ];
        };
        nixos-wsl = nixpkgs.lib.nixosSystem {
          specialArgs = {
            flakeinputs = inputs;
          };
          modules = [
            ./nixos/configuration.nix
            ./nixos/nixos-wsl.nix
            nixos-wsl.nixosModules.default
          ];
        };
      };
      homeConfigurations = {
        sharpchen = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home-manager/home.nix
            allowUnfree
          ];
          extraSpecialArgs = {
            inherit stable;
            flakeinputs = inputs;
          };
        };
      };
    };
}
