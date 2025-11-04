{
  description = "Home Manager configuration of sharpchen";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    stable.url = "github:nixos/nixpkgs/nixos-25.05";
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
        nixos-wsl = nixpkgs.lib.nixosSystem {
          specialArgs = {
            flakeinputs = inputs;
          };
          modules = [
            ./nixos/configuration.nix
            nixos-wsl.nixosModules.default
            {
              wsl.enable = true;
              wsl.defaultUser = "sharpchen";
              wsl.interop.includePath = false;
              wsl.wslConf.interop.appendWindowsPath = false;
              # NOTE: see https://github.com/nix-community/NixOS-WSL/issues/262
              systemd.services.wsl-vpnkit = {
                enable = true;
                description = "wsl-vpnkit";
                after = [ "network.target" ];
                serviceConfig = {
                  ExecStart = "${pkgs.wsl-vpnkit}/bin/wsl-vpnkit";
                  Restart = "always";
                  KillMode = "mixed";
                };
              };
            }
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
