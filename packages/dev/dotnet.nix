{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # dotnetCorePackages.sdk_8_0_1xx
    dotnetCorePackages.sdk_9_0
    netcoredbg
    csharpier
    roslyn-ls
    fsautocomplete
  ];
}
