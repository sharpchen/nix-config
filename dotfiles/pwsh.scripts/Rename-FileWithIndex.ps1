#Requires -PSEdition Core
#Requires -Modules PwshProfile

[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param (
    [Parameter(Mandatory)]
    [string[]]$Names,
    [Parameter(Mandatory)]
    [System.IO.FileInfo[]]$Files,
    # whether to fill 0 for indices
    [switch]$NoIndexPadding
)

begin {
    $idxPattern = '^\d+'
    $orderedFiles = $Files | Sort-Object { [int][regex]::Match($_.Name, $idxPattern).Value }
    $invalidChar = [regex]::Escape(':"<>|?*/\')
}

end {
    if ($orderedFiles | Where-Object { $_.Name -notmatch $idxPattern } -OutVariable invalid) {
        Write-Warning 'Following files has no index, please verify:'
        Write-Host $invalid.FullName
        return
    }

    $maxFile = $orderedFiles[-1]
    $maxIdxDigitCount = [regex]::Match($maxFile.Name, $idxPattern).Value.Length

    if ($orderedFiles.Count -ne $names.Count) {
        throw "Count of names and files doesn't match"
    }

    for ($idx = 0; $idx -lt $orderedFiles.Count; $idx++) {
        $file = $orderedFiles[$idx]
        $fileIdx = [int][regex]::Match($file.Name, $idxPattern).Value

        $nameFromSource = if ($Names[$idx] -match "[$invalidChar]") {
            $Names[$idx] -replace "[$invalidChar]", '_'
        } else {
            $Names[$idx]
        }

        $idxStr = if ($NoIndexPadding) {
            "$fileIdx"
        } else {
            "{0:$('0' * $maxIdxDigitCount)}" -f $fileIdx
        }

        $newName = "$idxStr $($nameFromSource)$($file.Extension)"

        if ($PSCmdlet.ShouldProcess("Renaming `"$($file.Name)`" => `"$newName`"", $null, $null)) {
            Rename-Item $file $newName
        }
    }
}
