{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  nix-update-script,
}:
let
  owner = "Eugenenoble2005";
  repo = "Avalonia-ls";
  dotnet-sdk = dotnetCorePackages.sdk_9_0;
in
buildDotnetModule {
  pname = "avalonia-ls";
  version = "0.0.1";
  src = fetchFromGitHub {
    inherit owner repo;
    rev = "c2e21ee62e139c1d4f81589d64f45b55c8068dc8";
    hash = "sha256-3ZmZy6/6fVbeJrZham5Nwx3mAk2y0IGLst1tYlmxdys=";
    fetchSubmodules = true;
  };

  projectFile = [
    "src/AvaloniaLSP/AvaloniaLanguageServer/AvaloniaLanguageServer.csproj"
    "src/SolutionParser/SolutionParser.csproj"
    "src/AvaloniaPreview/AvaloniaPreview.csproj"
  ];

  dotnetInstallFlags = [ "-p:TargetFramework=net9.0" ];
  inherit dotnet-sdk;

  nugetDeps = ./deps.json;
  useDotnetFromEnv = true;
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "";
    homepage = "";
    license = licenses.mit;
    maintainers = with maintainers; [ sharpchen ];
    platforms = platforms.linux;
    mainProgram = "";
  };
}
