if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
    Install-Module -Name PSReadLine -Force -Scope CurrentUser
}

if ($IsWindows) {
    if (-not (Get-Module -ListAvailable -Name Microsoft.WinGet.CommandNotFound)) {
        Install-Module -Name Microsoft.WinGet.CommandNotFound -Force -Scope CurrentUser
    }
    Import-Module -Name Microsoft.WinGet.CommandNotFound
}

Import-Module PSReadLine -ErrorAction SilentlyContinue

Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Cursor
Set-PSReadlineKeyHandler -Key "Ctrl+ " -Function MenuComplete
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key 'Ctrl+p' -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key 'Ctrl+n' -Function HistorySearchForward

New-Alias lg lazygit

function :q {
    exit
}

