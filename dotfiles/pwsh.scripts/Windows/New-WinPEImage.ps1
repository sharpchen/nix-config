# Requires Windows ADK & Windows PE addon for Windows ADK
# note that checking 'Deployment Tools' during installing ADK is sufficient
# https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install

<#
    Usage:
      1. Open 'Deployment and Imaging Tools Environment' command prompt
      2. Enter powershell/pwsh
      3. ./New-WinPEImage.ps1 -OutPath WinPE_amd64.iso
#>
param(
    [ValidateScript({ (Split-Path $_ -Extension) -eq '.iso' })]
    [Parameter(Mandatory)]
    [string]$OutPath,
    [ValidateSet('amd64', 'arm64', 'x86')]
    [string]$Architecture = 'amd64'
)

begin {
    $copype = Get-Command copype -ErrorAction Stop
    $null = Get-Command Dism -ErrorAction Stop
    $null = Get-Command MakeWinPEMedia -ErrorAction Stop

    $workingFolder = Join-Path $env:TEMP (New-Guid)
    $mount = Join-Path $workingFolder 'mount'
    $boot = Join-Path $workingFolder 'media/sources/boot.wim'
    $winpePackageRoot = Join-Path (Split-Path $copype.Source -Parent) "$Architecture\WinPE_OCs"
}

end {
    try {
        & $copype $Architecture $workingFolder

        Dism /Mount-Image /ImageFile:"$boot" /Index:1 /MountDir:"$mount"

        <#
        adding Optional Components(OC) to WinPE
        see: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-add-packages--optional-components-reference?view=windows-10
        #>

        # Windows Management Instrumentation (WMI) support
        Dism /Add-Package /Image:"$mount" /PackagePath:"$winpePackageRoot\WinPE-WMI.cab"
        Dism /Add-Package /Image:"$mount" /PackagePath:"$winpePackageRoot\en-us\WinPE-WMI_en-us.cab"

        # .NET framework support
        Dism /Add-Package /Image:"$mount" /PackagePath:"$winpePackageRoot\WinPE-NetFX.cab"
        Dism /Add-Package /Image:"$mount" /PackagePath:"$winpePackageRoot\en-us\WinPE-NetFX_en-us.cab"

        Dism /Add-Package /Image:"$mount" /PackagePath:"$winpePackageRoot\WinPE-Scripting.cab"
        Dism /Add-Package /Image:"$mount" /PackagePath:"$winpePackageRoot\en-us\WinPE-Scripting_en-us.cab"

        # PowerShell Desktop edition support
        Dism /Add-Package /Image:"$mount" /PackagePath:"$winpePackageRoot\WinPE-PowerShell.cab"
        Dism /Add-Package /Image:"$mount" /PackagePath:"$winpePackageRoot\en-us\WinPE-PowerShell_en-us.cab"

        # PowerShell Dism cmdlets
        # see: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/use-dism-in-windows-powershell-s14?view=windows-10
        Dism /Add-Package /Image:"$mount" /PackagePath:"$winpePackageRoot\WinPE-DismCmdlets.cab"
        Dism /Add-Package /Image:"$mount" /PackagePath:"$winpePackageRoot\en-us\WinPE-DismCmdlets_en-us.cab"

        # PowerShell cmdlets for storage management, Get-Disk etc.
        Dism /Add-Package /Image:"$mount" /PackagePath:"$winpePackageRoot\WinPE-StorageWMI.cab"
        Dism /Add-Package /Image:"$mount" /PackagePath:"$winpePackageRoot\en-us\WinPE-StorageWMI_en-us.cab"

        Dism /Unmount-Image /MountDir:"$mount" /Commit

        MakeWinPEMedia /ISO $workingFolder $OutPath
    } finally {
        # just in case Dism somehow doesn't unmount successfully
        # not sure whether necessary
        Dism /Cleanup-Wim

        if (Test-Path $workingFolder) {
            Remove-Item $workingFolder -Recurse -Force
        }
    }
}
