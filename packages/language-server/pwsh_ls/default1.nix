{ pkgs }:#buildDotnetModule, powershell, dotnetCorePackages, lib, fetchFromGitHub, stdenvNoCC, ... }:

let
  # pkgs = import <nixpkgs> {};
  repo = "PowerShellEditorServices";
  platyPS = (pkgs.callPackage ../platyPS/default.nix { inherit pkgs; });
in 
pkgs.buildDotnetModule rec {
  pname = "powershell-editor-services";
  version = "4.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "PowerShell";
    inherit repo;
    rev = "v${version}";
    hash = "sha256-nOVPs/lnS3vm+mef796g5AnVV0UDoIeuifgkWCTNDyo=";
  };

  buildInputs = [
    pkgs.powershell
    pkgs.git
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
    platyPS
  ];

  projectFile = "${repo}.sln";
  nugetDeps = ./deps.nix;
  dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0_1xx;

  preBuild = ''
    declare -r script_name='PowerShellEditorServices.build.ps1'

    pwsh -noprofile -c "Set-Content $script_name -Value (gc $script_name | % { \$_ -cmatch '#Requires' ? [string]::Empty : \$_ })"

    command=$(cat <<'EOF'
      [string[]]$prepend = @(
          '$env:PSModulePath += ":${platyPS}"',
          'ipmo platyPS',
          'Register-PSRepository -Default'
      )

      $paramBlock = [string]::Empty
      $content = gc ./PowerShellEditorServices.build.ps1
      # Task SetupHelpForTests requires network access, remove it.
      if ($content -join "`n" -match '(?s)param\s*.*?\s\)') {
          $paramBlock = $matches[0] -split "`n"
          $content = $content -join "`n" -replace '(?s)param\s*.*?\s\)', [string]::Empty
          # if ($content -match '(?s)Task SetupHelpForTests\s*{(?<body>.*?)}') {
            # $content = $content -replace $matches.body, [string]::Empty
          # }
          $content = $content -split "`n" | % { $_ -match 'Update-Help' ? [string]::Empty : $_ }
      }
      $content = $paramBlock + $prepend + $content
      Set-Content ./PowerShellEditorServices.build.ps1 -Value $content
    EOF
    )
    pwsh -noprofile -c "$command"
  '';

  buildPhase = ''
    runHook preBuild
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
