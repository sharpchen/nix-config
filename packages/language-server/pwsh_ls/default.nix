{ pkgs }:#buildDotnetModule, powershell, dotnetCorePackages, lib, fetchFromGitHub, stdenvNoCC, ... }:

let
  # pkgs = import <nixpkgs> {};
in 
pkgs.buildDotnetModule rec {
  pname = "PowerShellEditorServices";
  version = "4.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "PowerShell";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nOVPs/lnS3vm+mef796g5AnVV0UDoIeuifgkWCTNDyo=";
  };

  buildInputs = [
    pkgs.powershell
    (pkgs.callPackage ({}: pkgs.buildDotnetGlobalTool {
      pname = "ib";
      version = "5.12.1";
      nugetHash = "sha256-cwSm0s1EFKL2Fe262cjiPpP9eWY136ikp2dy2k1wvaA=";
      meta = {
        homepage = "https://github.com/nightroman/Invoke-Build";
        license = pkgs.lib.licenses.asl20;
        platforms = ["x86_64-linux"];
      };
    }) {})
    (pkgs.callPackage ../platyPS/default.nix { inherit pkgs; })
  ];

  projectFile = "${pname}.sln";
  nugetDeps = ./deps.nix;
  dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0_1xx;

  buildPhase = ''
    cd $src; 
    pwsh -noprofile -c "Set-Content $src/${pname}.build.ps1 -Value (gc $src/${pname} | % { \$_ -cmatch '#Requires' ? [string]::Empty : \$_ })"
    ib
  '';

  meta = with pkgs.lib; {
    description = "A common platform for PowerShell development support in any editor or application!";
    homepage = "https://github.com/PowerShell/PowerShellEditorServices";
    license = with licenses; [
      mit
    ];
    # maintainers = with maintainers; [ gepbird thiagokokada ];
    platforms = [ "x86_64-linux" ];
    # mainProgram = "osu!";
  };
}
