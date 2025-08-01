if ($Host.Name -ne 'ConsoleHost') {
    Write-Information 'Current Host is not ConsoleHost'
    return
}

$env:DOTNET_CLI_UI_LANGUAGE = 'en'
if (Test-Path ~/.fzfrc) {
    $env:FZF_DEFAULT_OPTS_FILE = (Resolve-Path ~/.fzfrc).Path
}

if ($IsLinux -or $IsMacOS) {
    $env:MANPAGER = 'nvim +Man!'
}

Set-PsFzfOption -TabExpansion

$IsLegacy = $PSVersionTable.PSEdition -eq 'Desktop'

if ($IsWindows -or $IsLegacy) {
    [Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
}

if ($IsLegacy) {
    Set-PSReadLineOption -ViModeIndicator Prompt
} else {
    $OnViModeChange = {
        if ($args[0] -eq 'Command') {
            # Set the cursor to a blinking block.
            Write-Host -NoNewline "`e[2 q"
        } else {
            # Set the cursor to a blinking line.
            Write-Host -NoNewline "`e[5 q"
        }
    }
    Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $OnViModeChange
}

$syntaxColors = @{
    Parameter = 'Magenta'
    Operator  = 'Cyan'
    Type      = 'Cyan'
    Keyword   = 'Magenta'
    Command   = 'Blue'
    Number    = 'Yellow'
    Member    = 'Red'
    String    = 'Green'
}

if ((Get-Module -Name PSReadLine).Version -lt '2.0.0') {
    $syntaxColors.Keys | ForEach-Object {
        Set-PSReadLineOption -TokenKind $_ -ForegroundColor $syntaxColors[$_]
    }
} else {
    Set-PSReadLineOption -Colors $syntaxColors
}

function prompt {
    if ($IsLinux -or $IsMacOS) {
        return "PS $($pwd.ProviderPath -replace '/home/[a-zA-Z0-9]+', '~')$('>' * ($nestedPromptLevel + 1)) "
    }
    $pattern = 'C:\\Users\\[a-zA-Z0-9]+'
    $path = if ($pwd.ProviderPath -match $pattern) {
        "~$($pwd.ProviderPath -replace $pattern, [string]::Empty)"
    } else {
        $pwd.ProviderPath
    }

    return "PS $path$('>' * ($nestedPromptLevel + 1)) "
}
