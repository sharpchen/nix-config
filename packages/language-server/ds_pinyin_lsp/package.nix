{
  stdenvNoCC,
  fetchzip,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  pname = "ds-pinyin-lsp";
  version = "0.4.0";

  srcs = [
    (fetchzip {
      name = "ds-pinyin-lsp-exe";
      url = "https://github.com/iamcco/ds-pinyin-lsp/releases/download/v${version}/ds-pinyin-lsp_v${version}_x86_64-unknown-linux-musl.zip";
      hash = "sha256-0AX/FqAvf4L3jt64KNKIrEl3oK1jvVk2jL3vbbYjwZQ=";
    })

    (fetchzip {
      name = "ds-pinyin-lsp-dict";
      url = "https://github.com/iamcco/ds-pinyin-lsp/releases/download/v${version}/dict.db3.zip";
      hash = "sha256-csS+5Hi+mImO79zyvpFKjjkGK1WNOQ5VTZq3vB0D7bg=";
    })
  ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib
    mv ${(builtins.elemAt srcs 0).name}/ds-pinyin-lsp $out/bin
    chmod +x $out/bin/ds-pinyin-lsp
    mv ${(builtins.elemAt srcs 1).name}/dict.db3 $out/lib
  '';

  meta = {
    description = "Dead Simple Pinyin Language Server";
    homepage = "https://github.com/iamcco/ds-pinyin-lsp";
    changelog = "https://github.com/iamcco/ds-pinyin-lsp/blob/master/CHANGELOD.md";
    platforms = lib.platforms.unix;
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ sharpchen ];
    mainProgram = "ds-pinyin-lsp";
  };
}
