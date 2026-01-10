param (
    $commandName,
    $parameterName,
    $wordToComplete,
    $commandAst,
    $fakeBoundParameters
)

if ($fakeBoundParameters.ContainsKey('Port')) {
    $flags = @('-P', $fakeBoundParameters.Port, 'devices', '-l')
} else {
    $flags = @('devices', '-l')
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
