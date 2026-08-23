{
  lib,
  fetchFromGitHub,
  dotnetCorePackages,
  buildDotnetModule,
  nix-update-script,
}:
let
  owner = "tintoy";
  repo = "msbuild-project-tools-server";
  dotnet-sdk = dotnetCorePackages.sdk_8_0_1xx;
in
buildDotnetModule rec {
  pname = repo;
  version = "0.7.0";
  src = fetchFromGitHub {
    inherit owner repo;
    rev = "v${version}";
    hash = "sha256-4ylX5+3zMvZMV1QbsOoTpDUaskbA7lhymq21cEroK3k=";
  };

  nugetDeps = ./deps.json;
  projectFile = "src/LanguageServer/LanguageServer.csproj";
  inherit dotnet-sdk;
  useDotnetFromEnv = true;
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "";
    homepage = "";
    license = licenses.mit;
    maintainers = with maintainers; [ sharpchen ];
    platforms = platforms.unix;
    mainProgram = "MSBuildProjectTools.LanguageServer.Host";
  };
}
