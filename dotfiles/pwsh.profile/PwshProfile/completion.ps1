$dotnetcomplete = {
    param(
        $wordToComplete,
        $commandAst,
        $cursorPosition
    )

    dotnet complete --position $cursorPosition $commandAst.ToString() | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new(
            $_,               # completionText
            $_,               # listItemText
            'ParameterValue', # resultType
            $_                # toolTip
        )
    }
}
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock $dotnetcomplete
Register-ArgumentCompleter -CommandName dn -ScriptBlock $dotnetcomplete

Register-ArgumentCompleter -CommandName rd -ParameterName Path -ScriptBlock {
    param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )
    $path = Resolve-Path "$wordToComplete*" -ErrorAction Ignore
    $default = Get-ChildItem -LiteralPath $path -Directory
    $res = $default | Where-Object Name -Like "*$wordToComplete*"
    if ($res) {
        $res | ForEach-Object Name
    } else {
        # NOTE: $res might be empty
        # so we fallback to all folders
        $default | ForEach-Object Name
    }
}
