{
  buildDotnetModule ? null,
  fetchFromGitHub ? null,
  runtimeShell,
  # dotnetCorePackages,
  pkgs,
}:
let
  # pkgs = import <nixpkgs> { };
  owner = "Eugenenoble2005";
  repo = "Avalonia-ls";
  dotnet-sdk = pkgs.dotnetCorePackages.sdk_9_0;
in
pkgs.stdenv.mkDerivation {
  pname = repo;
  version = "0.0.1";
  src = pkgs.fetchFromGitHub {
    inherit owner repo;
    rev = "5c64ff84f92d822852eb3ecef1cb5eea8c2f152c";
    hash = "sha256-bORSuvNYXtEp/f1ZI+gXBM66z0LFhFOZh+j9I75PrKQ=";
  };

  buildInputs = [
    pkgs.just
    dotnet-sdk
  ];

  buildPhase = ''
    mkdir -p bin/lsp
    dotnet build src/AvaloniaLSP/AvaloniaLanguageServer --output bin/lsp

    mkdir -p bin/solution-parser
    dotnet build src/SolutionParser/SolutionParser.csproj --output bin/solution-parser

    mkdir -p bin/xaml-styler
    dotnet build src/XamlStyler/src/XamlStyler.Console/XamlStyler.Console.csproj --output bin/xaml-styler

    mkdir -p bin/avalonia-preview
    dotnet build src/AvaloniaPreview --output bin/avalonia-preview
  '';

  installPhase = ''
    just build
    mkdir -p $out/avalonia-ls
    cp bin/* $out/avalonia-ls -r
    echo -e "#!${runtimeShell}\n exec $out/bin/avalonia-ls/xaml-styler/xstyler \"\$@\"" > $out/bin/xaml-styler
    chmod +x $out/bin/xaml-styler

    echo -e "#!${runtimeShell}\n exec $out/bin/avalonia-ls/lsp/AvaloniaLanguageServer \"\$@\"" > $out/bin/avalonia-ls
    chmod +x $out/bin/avalonia-ls

    echo -e "#!${runtimeShell}\n exec $out/bin/avalonia-ls/solution-parser/SolutionParser \"\$@\"" > $out/bin/avalonia-solution-parser
    chmod +x $out/bin/avalonia-solution-parser

    echo -e "#/!bin/bash\n exec $out/bin/avalonia-ls/avalonia-preview/AvaloniaPreview \"\$@\"" > $out/bin/avalonia-preview
    chmod +x $out/bin/avalonia-preview
  '';

  meta = with pkgs.lib; {
    description = "";
    homepage = "";
    license = licenses.mit;
    maintainers = with maintainers; [ sharpchen ];
    platforms = platforms.unix;
    mainProgram = "";
  };
}
