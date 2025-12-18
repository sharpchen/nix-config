[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param (
    [ArgumentCompleter({
            $raw = bcdedit /enum firmware
            $result = @()
            $shouldAddToResult = $true
            for ($i = 0; $i -lt $raw.Count; $i++) {
                $line = $raw[$i]
                # ----------
                # header start for each entry, reaching this line means it have enumerated lines of previous entry
                if ($line -match '^-+$' -or $i -eq $raw.Count - 1) {
                    $shouldAddToResult = -not $shouldAddToResult
                }

                if ($line -match '^identifier') {
                    $id = $line -split '\s+', 2 | Select-Object -Last 1
                } elseif ($line -match '^description') {
                    $desc = $line -split '\s+', 2 | Select-Object -Last 1
                }

                if ($shouldAddToResult) {
                    if ($id) {
                        if (-not $desc) {
                            $desc = $id
                        }
                        $result += [System.Management.Automation.CompletionResult]::new(
                            "'$id'",               # real result
                            $desc,               # label in list
                            [System.Management.Automation.CompletionResultType]::ParameterValue,
                            $desc              # toolTip
                        )
                    }
                    $shouldAddToResult = $false
                    $id = $desc = $null
                }
            }
            $result
        })]
    [string]$Identifier
)

if ($PSCmdlet.ShouldProcess("bcdedit /delete $Identifier", $null, $null)) {
    bcdedit /delete $Identifier
}
