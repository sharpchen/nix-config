using namespace System.Collections
using namespace System.Management.Automation

$global:__comp_file = {
    param (
        [string]$commandName,
        [string]$parameterName,
        [string]$wordToComplete,
        [Language.CommandAst]$commandAst,
        [IDictionary]$fakeBoundParameters
    )
    Get-ChildItem -Filter "*$wordToComplete*" -File -Force |
        Resolve-Path -Relative -RelativeBasePath $PWD -ErrorAction Ignore |
        ForEach-Object {
            "'$($_ -replace "'", "''")'"
        }
}

$global:__comp_file_native = {
    param(
        [string]$wordToComplete,
        [Language.CommandAst]$commandAst,
        [int]$cursorPosition
    )
    Get-ChildItem -Filter "*$wordToComplete*" -File -Force |
        Resolve-Path -Relative -RelativeBasePath $PWD -ErrorAction Ignore |
        ForEach-Object {
            "'$($_ -replace "'", "''")'"
        }
}

$global:__comp_folder = {
    param (
        [string]$commandName,
        [string]$parameterName,
        [string]$wordToComplete,
        [Language.CommandAst]$commandAst,
        [IDictionary]$fakeBoundParameters
    )

    Get-ChildItem -Filter "*$wordToComplete*" -Directory -Force |
        Resolve-Path -Relative -RelativeBasePath $PWD -ErrorAction Ignore |
        ForEach-Object {
            "'$($_ -replace "'", "''")'"
        }
}

$global:__comp_folder_native = {
    param(
        [ArgumentCompleterFactoryAttribute]
        [string]$wordToComplete,
        [Language.CommandAst]$commandAst,
        [int]$cursorPosition
    )

    Get-ChildItem -Filter "*$wordToComplete*" -Directory -Force |
        Resolve-Path -Relative -RelativeBasePath $PWD -ErrorAction Ignore |
        ForEach-Object {
            "'$($_ -replace "'", "''")'"
        }
}

$__dotnetcomplete = {
    param(
        [string]$wordToComplete,
        [Language.CommandAst]$commandAst,
        [int]$cursorPosition
    )

    dotnet complete --position $cursorPosition $commandAst.ToString() | ForEach-Object {
        [CompletionResult]::new(
            $_,               # completionText
            $_,               # listItemText
            [CompletionResultType]::ParameterValue,
            $_                # toolTip
        )
    }
}

$global:__comp_sys_env = {
    param (
        [string]$commandName,
        [string]$parameterName,
        [string]$wordToComplete,
        [Language.CommandAst]$commandAst,
        [IDictionary]$fakeBoundParameters
    )

    $target = if ($fakeBoundParameters.ContainsKey('Target')) {
        $fakeBoundParameters['Target']
    } else {
        [System.EnvironmentVariableTarget]::User
    }

    [System.Environment]::GetEnvironmentVariables($target).Keys
}

# native complete
Register-ArgumentCompleter -CommandName dn -ScriptBlock $__dotnetcomplete
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock $__dotnetcomplete
Register-ArgumentCompleter -Native -CommandName ll -ScriptBlock $global:__comp_folder_native
Register-ArgumentCompleter -Native -CommandName file -ScriptBlock $global:__comp_file_native

# non-native complete
Register-ArgumentCompleter -CommandName rd -ParameterName LiteralPath -ScriptBlock $global:__comp_folder
