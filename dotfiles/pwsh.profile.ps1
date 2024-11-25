if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
    Install-Module -Name PSReadLine -Force -Scope CurrentUser
}

if ($IsWindows) {
    if (-not (Get-Module -ListAvailable -Name Microsoft.WinGet.CommandNotFound)) {
        Install-Module -Name Microsoft.WinGet.CommandNotFound -Force -Scope CurrentUser
    }
    Import-Module -Name Microsoft.WinGet.CommandNotFound

    ## project search
    function proj {
        sl (gci '~/Projects' -Directory | foreach FullName | fzf)
    }
}

Import-Module PSReadLine -ErrorAction SilentlyContinue

Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Prompt # Cursor

$syntaxColors = @{
    Parameter = 'Magenta'
    Operator = 'Cyan'
    Type = 'Cyan'
    Keyword = 'Magenta'
    Command = 'Blue'
    Number = 'Yellow'
    Member = 'Red'
}

if ((gmo -Name PSReadLine).Version -lt '2.0.0') {
    $syntaxColors.Keys | foreach {
        Set-PSReadlineOption -TokenKind $_ -ForegroundColor $syntaxColors[$_]
    }
} else {
    Set-PSReadLineOption -Colors $syntaxColors
}

Set-PSReadlineKeyHandler -Key "Ctrl+ " -Function MenuComplete
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key 'Ctrl+p' -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key 'Ctrl+n' -Function HistorySearchForward

Set-Alias lg lazygit

function :q {
    exit
}

