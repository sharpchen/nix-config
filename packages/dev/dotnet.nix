{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (
      with dotnetCorePackages;
      combinePackages [
        sdk_9_0
        # sdk_10_0-bin
      ]
    )
    netcoredbg
    csharpier
    roslyn-ls
    rzls
    fsautocomplete
    fantomas
    ilspycmd
    csharp-ls
  ];
}
