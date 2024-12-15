{ pkgs }:#buildDotnetModule, powershell, dotnetCorePackages, lib, fetchFromGitHub, stdenvNoCC, ... }:

let
  # pkgs = import <nixpkgs> {};
in 
  pkgs.buildDotnetModule rec {
    pname = "platyPS";
    version = "0.14.2";

    src = pkgs.fetchFromGitHub {
      owner = "PowerShell";
      repo = pname;
      rev = version;
      hash = "sha256-RTbXCsGFGgbgmzBHjxRROsY4d5AbHJ1Jq3fQNa+SZAM=";
    };

    nugetDeps = ./deps.nix;
    projectFile = "Markdown.MAML.sln";

    buildInputs = [pkgs.powershell pkgs.dotnetCorePackages.sdk_8_0_1xx];
    buildPhase = ''
      [[ -d $src/out ]] && rm -rf $src/out
      cp $src/docs/developer/platyPS/platyPS.schema.md $src
      pwsh -noprofile -f $src/build.ps1
      pwsh -noprofile -c "cpi -rec $src/out -dest (''$env:PSModulePath -split ':' | select -first 1)"
    '';

    meta = with pkgs.lib; {
      description = "Write PowerShell External Help in Markdown";
      homepage = "https://github.com/PowerShell/platyPS";
      license = with licenses; [
        mit
      ];
      maintainers = with maintainers; [ sharpchen ];
      platforms = [ "x86_64-linux" ];
      # mainProgram = "osu!";
    };
  }
