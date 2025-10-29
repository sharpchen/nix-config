$filecomplete = {
    param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )
    Resolve-Path "*$wordToComplete*" -Relative -ErrorAction Ignore |
        Where-Object { [IO.File]::Exists($_) }
}

$foldercomplete = {
    param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )
    Resolve-Path "*$wordToComplete*" -Relative -ErrorAction Ignore |
        Where-Object { [IO.Directory]::Exists($_) }
}

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
Register-ArgumentCompleter -CommandName rd -ParameterName Path -ScriptBlock $foldercomplete
