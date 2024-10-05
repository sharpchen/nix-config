{
  pkgs,
  ...
}:
let
  inherit (pkgs) stdenv fetchFromGitHub;
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
    pkgs.nodejs_18
    pkgs.pnpm_8
  ];

  buildPhase = ''
    export NPM_CONFIG_REGISTRY="https://registry.npmmirror.com"
    git submodule update --init
    pnpm install
    pnpm build
  '';

  installPhase = ''
    mkdir -p $out/bin/vtsls
    cd $src/packages/server
    npm install --prod
    cp -r node_modules/.bin/* $out/bin/
  '';

})
