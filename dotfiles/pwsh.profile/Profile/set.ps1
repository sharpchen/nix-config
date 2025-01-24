Import-Module PSReadLine

if ($IsWindows) {
    if (-not (Get-Module -ListAvailable -Name Microsoft.WinGet.CommandNotFound)) {
        Install-Module -Name Microsoft.WinGet.CommandNotFound -Force -Scope CurrentUser
    }
    Import-Module -Name Microsoft.WinGet.CommandNotFound
}

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

$syntaxColors = @{
    Parameter = 'Magenta'
    Operator = 'Cyan'
    Type = 'Cyan'
    Keyword = 'Magenta'
    Command = 'Blue'
    Number = 'Yellow'
    Member = 'Red'
    String = 'Green'
}

if ((Get-Module -Name PSReadLine).Version -lt '2.0.0') {
    $syntaxColors.Keys | ForEach-Object {
        Set-PSReadLineOption -TokenKind $_ -ForegroundColor $syntaxColors[$_]
    }
} else {
    Set-PSReadLineOption -Colors $syntaxColors
}
