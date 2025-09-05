{ pkgs, config, ... }:
let
  dotnet-combined = (
    with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_9_0
      # sdk_10_0-bin
    ]
  );
in
{
  home.packages = with pkgs; [
    dotnet-combined
    netcoredbg
    csharpier
    roslyn-ls
    rzls
    fsautocomplete
    fantomas
    ilspycmd
    csharp-ls
  ];

  home.sessionVariables = {
    DOTNET_ROOT = "${dotnet-combined}/share/dotnet";
    DOTNET_PATH = "${dotnet-combined}/bin/dotnet";
  };
  home.sessionPath = [ "${config.home.homeDirectory}/.dotnet/tools/" ];
  home.shellAliases = {
    dn = "dotnet";
  };
}
