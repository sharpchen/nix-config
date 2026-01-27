param (
    $commandName,
    $parameterName,
    $wordToComplete,
    $commandAst,
    $fakeBoundParameters
)

$flags = @()

if ($fakeBoundParameters.ContainsKey('Port')) {
    $flags += '-P', $fakeBoundParameters.Port
}
if ($fakeBoundParameters.ContainsKey('SerialNumber')) {
    $flags += '-s', $fakeBoundParameters.SerialNumber
}

# -3 third-party packages only
# -s system packages only
adb @flags shell pm list packages | ForEach-Object { $_ -replace '^package:', '' }
