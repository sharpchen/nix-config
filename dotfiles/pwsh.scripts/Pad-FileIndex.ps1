#Requires -PSEdition Core

# Rename file with index padding
# 1-foo.mp4
# ...
# 10-bar.mp4

# becomes
# 01-foo.mp4
# 02-baz.mp4
# ...
# 10-bar.mp4

[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param (
    [Parameter(Mandatory)]
    [System.IO.FileInfo[]]$Files
)

$max_idx = $Files
    | ForEach-Object { [int][regex]::Match($_.Name, '^\d+').Value }
    | Sort-Object -Descending
    | Select-Object -First 1

$max_idx_digits = $max_idx.ToString().Length

foreach ($file in $Files) {
    $idx = [int][regex]::Match($file.Name, '^\d+').Value
    $padded = "{0:$('0' * $max_idx_digits)}" -f $idx
    $newName = $file.Name -replace '^\d+', $padded

    if ($PSCmdlet.ShouldProcess("Renaming `"$($file.Name)`" => `"$newName`"", $null, $null)) {
        Rename-Item $file $newName
    }
}
