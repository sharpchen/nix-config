{
  stdenvNoCC,
  fetchzip,
  lib,
  powershell,
  makeWrapper,
  bash,
}:
let
  owner = "PowerShell";
  repo = "PowerShellEditorServices";
in
stdenvNoCC.mkDerivation rec {
  pname = "powershell-editor-services";
  version = "4.1.0";

  src = fetchzip {
    name = "${repo}";
    url = "https://github.com/${owner}/${repo}/releases/download/v${version}/${repo}.zip";
    hash = "sha256-B6RF4RoJB+C5i6puZhfy6FZzyZ9eMo81dd0XsaIEK6Q=";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
  ];

  installPhase = ''
    mkdir -p $out/{lib,bin}
    mv * $out/lib/
    cat > $out/bin/${pname} <<EOF
    #! ${bash}/bin/bash -e
    exec "${powershell}/bin/pwsh" -noprofile -nologo -c "$out/lib/${repo}/Start-EditorServices.ps1 \$@"
    EOF
    chmod +x $out/bin/*
  '';

  postInstall = ''
    wrapProgram $out/bin/${pname} --set PATH "$PATH:$out/bin"
  '';

  meta = {
    description = "A common platform for PowerShell development support in any editor or application!";
    homepage = "https://github.com/PowerShell/PowerShellEditorServices";
    changelog = "https://github.com/PowerShell/PowerShellEditorServices/releases/tag/v${version}";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sharpchen ];
    mainProgram = pname;
  };
}
