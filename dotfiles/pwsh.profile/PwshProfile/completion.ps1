$__filecomplete = {
    param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )
    Get-ChildItem -Filter "*$wordToComplete*" -File -Force |
        Resolve-Path -Relative -RelativeBasePath $PWD -ErrorAction Ignore
}

$__filecompletenative = {
    param(
        $wordToComplete,
        $commandAst,
        $cursorPosition
    )
    Get-ChildItem -Filter "*$wordToComplete*" -File -Force |
        Resolve-Path -Relative -RelativeBasePath $PWD -ErrorAction Ignore
}

$__foldercomplete = {
    param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )
    Get-ChildItem -Filter "*$wordToComplete*" -Directory -Force |
        Resolve-Path -Relative -RelativeBasePath $PWD -ErrorAction Ignore
}

$__foldercompletenative = {
    param(
        $wordToComplete,
        $commandAst,
        $cursorPosition
    )

    Get-ChildItem -Filter "*$wordToComplete*" -Directory -Force |
        Resolve-Path -Relative -RelativeBasePath $PWD -ErrorAction Ignore
}

$__cmdcomplete = {
    param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )
    [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
}

$__cmdcompletenative = {
    param(
        $wordToComplete,
        $commandAst,
        $cursorPosition
    )
    [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
}

$__dotnetcomplete = {
    param(
        $wordToComplete,
        $commandAst,
        $cursorPosition
    )

    dotnet complete --position $cursorPosition $commandAst.ToString() | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new(
            $_,               # completionText
            $_,               # listItemText
            [System.Management.Automation.CompletionResultType]::ParameterValue,
            $_                # toolTip
        )
    }
}

# native complete
Register-ArgumentCompleter -CommandName dn -ScriptBlock $__dotnetcomplete
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock $__dotnetcomplete
Register-ArgumentCompleter -Native -CommandName ll -ScriptBlock $__foldercompletenative
Register-ArgumentCompleter -Native -CommandName file -ScriptBlock $__filecompletenative
Register-ArgumentCompleter -Native -CommandName which -ScriptBlock $__cmdcompletenative

# non-native complete
Register-ArgumentCompleter -CommandName rd -ParameterName LiteralPath -ScriptBlock $__foldercomplete
Register-ArgumentCompleter -CommandName unpack -ParameterName LiteralPath -ScriptBlock $__filecomplete
Register-ArgumentCompleter -CommandName unpack -ParameterName Destination -ScriptBlock $__foldercomplete
Register-ArgumentCompleter -CommandName epubpack -ParameterName Folder -ScriptBlock $__foldercomplete
Register-ArgumentCompleter -CommandName play -ParameterName LiteralPath -ScriptBlock $__filecomplete
