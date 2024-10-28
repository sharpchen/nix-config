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

if ($IsWindows) {
    Import-Module -Name Microsoft.WinGet.CommandNotFound
}
