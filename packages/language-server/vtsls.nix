{
  pkgs ? import <nixpkgs>
}:
let
  inherit (pkgs) stdenv nodejs pnpm fetchFromGitHub;
in
stdenv.mkDerivation (finalAttrs: rec {
  pname = "@vtsls/language-server";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "yioneko";
    repo = "vtsls";
    rev = "main";
    sha256="sha256-qaI2inIxpvFGcTivMWYyUL0Mo/byt6G8ZDyU21zxSLc=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  buildPhase = ''
    export NPM_CONFIG_REGISTRY="https://registry.npmmirror.com"
    pnpm install
    pnpm build
    cp package/server/bin $out/bin/
  '';

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
  };
})
