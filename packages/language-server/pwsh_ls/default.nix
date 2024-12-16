{
  stdenvNoCC,
  fetchzip,
  lib,
  powershell,
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
    name = repo;
    url = "https://github.com/${owner}/${repo}/releases/download/v${version}/${repo}.zip";
    hash = "sha256-B6RF4RoJB+C5i6puZhfy6FZzyZ9eMo81dd0XsaIEK6Q=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/{lib,bin}
    mkdir -p $out/lib/powershell-editor-services/
    mv * $out/lib/powershell-editor-services/
    cat > $out/bin/powershell-editor-services <<EOF
    #! ${bash}/bin/bash -e
    exec "${powershell}/bin/pwsh" -noprofile -nologo -c "$out/lib/PowerShellEditorServices/Start-EditorServices.ps1 \$@"
    EOF
    chmod +x $out/bin/*
  '';

  meta = with lib; {
    description = "Common platform for PowerShell development support in any editor or application";
    homepage = "https://github.com/PowerShell/PowerShellEditorServices";
    changelog = "https://github.com/PowerShell/PowerShellEditorServices/releases/tag/v${version}";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ sharpchen ];
    mainProgram = "powershell-editor-services";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
  };
}
