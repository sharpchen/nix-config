{
  nix-update-script,
  pkgs,
}:
let
  owner = "tintoy";
  repo = "msbuild-project-tools-server";
  dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0_1xx;
in
pkgs.buildDotnetModule rec {
  pname = repo;
  version = "0.6.6";
  src = pkgs.fetchFromGitHub {
    inherit owner repo;
    rev = "v${version}";
    hash = "sha256-dhE94gnH8s758a9JmdMXV2/7nzm4JD6mcVaq75NRXLQ=";
  };

  nugetDeps = ./deps.nix;
  projectFile = "src/LanguageServer/LanguageServer.csproj";
  inherit dotnet-sdk;
  useDotnetFromEnv = true;
  passthru.updateScript = nix-update-script { };

  meta = with pkgs.lib; {
    description = "";
    homepage = "";
    license = licenses.mit;
    maintainers = with maintainers; [ sharpchen ];
    platforms = platforms.unix;
    mainProgram = "MSBuildProjectTools.LanguageServer.Host";
  };
}
