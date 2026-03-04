$filecomplete = {
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

$filecompletenative = {
    param(
        $wordToComplete,
        $commandAst,
        $cursorPosition
    )
    Get-ChildItem -Filter "*$wordToComplete*" -File -Force |
        Resolve-Path -Relative -RelativeBasePath $PWD -ErrorAction Ignore
}

$foldercomplete = {
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

$foldercompletenative = {
    param(
        $wordToComplete,
        $commandAst,
        $cursorPosition
    )

    Get-ChildItem -Filter "*$wordToComplete*" -Directory -Force |
        Resolve-Path -Relative -RelativeBasePath $PWD -ErrorAction Ignore
}

$cmdcomplete = {
    param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )
    [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
}

$cmdcompletenative = {
    param(
        $wordToComplete,
        $commandAst,
        $cursorPosition
    )
    [System.Management.Automation.CompletionCompleters]::CompleteCommand($wordToComplete)
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
            [System.Management.Automation.CompletionResultType]::ParameterValue,
            $_                # toolTip
        )
    }
}

# native complete
Register-ArgumentCompleter -CommandName dn -ScriptBlock $dotnetcomplete
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock $dotnetcomplete
Register-ArgumentCompleter -Native -CommandName ll -ScriptBlock $foldercompletenative
Register-ArgumentCompleter -Native -CommandName file -ScriptBlock $filecompletenative
Register-ArgumentCompleter -Native -CommandName which -ScriptBlock $cmdcompletenative

# non-native complete
Register-ArgumentCompleter -CommandName rd -ParameterName Path -ScriptBlock $foldercomplete
Register-ArgumentCompleter -CommandName unpack -ParameterName Path -ScriptBlock $filecomplete
Register-ArgumentCompleter -CommandName unpack -ParameterName Destination -ScriptBlock $foldercomplete
Register-ArgumentCompleter -CommandName epubpack -ParameterName Folder -ScriptBlock $foldercomplete
