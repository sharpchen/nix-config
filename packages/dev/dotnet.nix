{ pkgs, ... }:
{
  home.packages = with pkgs;[
    dotnetCorePackages.sdk_8_0_1xx
    netcoredbg
    csharpier
    roslyn-ls
    fsautocomplete
  ];
}

