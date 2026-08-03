param (
    [string]$commandName,
    [string]$parameterName,
    [string]$wordToComplete,
    [System.Management.Automation.Language.CommandAst]$commandAst,
    [System.Collections.IDictionary]$fakeBoundParameters
)

$flags = 'devices', '-l'

if ($fakeBoundParameters.ContainsKey('Port')) {
    $flags = '-P', $fakeBoundParameters.Port + $flags
}

adb @flags | Select-Object -Skip 1 -SkipLast 1 | ForEach-Object {
    $serialNumber, $desc = $_ -split '\s+', 2
    [System.Management.Automation.CompletionResult]::new(
        $serialNumber,
        $desc,
        [System.Management.Automation.CompletionResultType]::ParameterValue,
        $desc
    )

}
