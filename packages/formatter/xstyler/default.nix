{
  pkgs,
}:
let
  owner = "Eugenenoble2005";
  repo = "XamlStyler";
  dotnet-sdk = pkgs.dotnetCorePackages.sdk_9_0;
in
pkgs.buildDotnetModule {
  pname = repo;
  version = "0.0.1";
  src = pkgs.fetchFromGitHub {
    inherit owner repo;
    rev = "b9435a072bb779db7b3561e015788733c82a55c5";
    hash = "sha256-Vq5zp09Cto07jiJA8o7wqv19JWrV5TzWgTP+uG/kOz0=";
  };

  nugetDeps = ./deps.json;
  projectFile = "src/XamlStyler.Console/XamlStyler.Console.csproj";
  inherit dotnet-sdk;
  useDotnetFromEnv = true;
  executable = [ "xstyler" ];
  dotnetInstallFlags = [ "-p:TargetFramework=net9.0" ];
  passthru.updateScript = pkgs.nix-update-script { };

  meta = with pkgs.lib; {
    description = "Code formatter for XAML files.";
    homepage = "https://github.com/Xavalon/XamlStyler";
    license = licenses.asl20;
    maintainers = with maintainers; [ sharpchen ];
    platforms = platforms.unix;
    mainProgram = "xstyler";
  };
}
