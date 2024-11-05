{ pkgs, ... }:
{
  home.packages = with pkgs;[
    dotnetCorePackages.sdk_8_0_4xx
    netcoredbg
    csharpier
    roslyn-ls
    fsautocomplete
  ];
}

