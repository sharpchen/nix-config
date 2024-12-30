function prompt {
    if ($IsWindows) {
        $pattern = 'C:\\Users\\[a-zA-Z0-9]+'
        $path = if ($pwd.ProviderPath -match $pattern) {
            "~$($pwd.ProviderPath -replace $pattern, '')" 
        } else { 
            $pwd.ProviderPath 
        }

        return "PS $path$('>' * ($nestedPromptLevel + 1)) "
    }
    return "PS $($pwd.ProviderPath -replace '/home/[a-zA-Z0-9]+', '~')$('>' * ($nestedPromptLevel + 1)) "
}

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
        Set-Location (Get-ChildItem '~/Projects' -Directory | ForEach-Object FullName | fzf)
    }

}

Import-Module PSReadLine -ErrorAction SilentlyContinue

Set-PSReadLineOption -EditMode Vi
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

Set-PSReadlineKeyHandler -Key 'Ctrl+ ' -Function MenuComplete
Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key 'Ctrl+p' -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key 'Ctrl+n' -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord ' , ' -Function DeleteWord -ViMode Command
Set-PSReadlineKeyHandler -Chord 'g,h' -Function GotoFirstNonBlankOfLine -ViMode Command
Set-PSReadlineKeyHandler -Chord 'g,l' -Function EndofLine -ViMode Command

Set-Alias lg lazygit
Set-Alias dn dotnet

function vim {
    nvim --clean -c 'source ~/.vimrc' @args
}

function :q {
    exit
}

function adbin([string]$Str, [switch]$Enter) {
    $special = @( ' ', '\|', '\$', '&', '\(', '\)', '~', '\*', "\'", '"', '<', '>')
    foreach ($char in $special) {
        $Str = $Str -replace $char, ($char.Length -gt 1 ? $char : "\$char")
    }
    adb shell input text $Str
    if ($Enter) {
        adb shell input keyevent KEYCODE_ENTER
    }
}

function iparam {
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [string]$Command,
        [switch]$Positional,
        [switch]$Pipeline
    )
    if ($Positional) {
        help $Command | Select-String 'Position\??\s*\d' -Context 3, 5
    } elseif ($Pipeline) {
        help $Command | Select-String 'Accept pipeline input\??\s*true.*$' -Context 5, 4
    }
}

if ((Get-Command 'home-manager' -ErrorAction SilentlyContinue)) {
    function hms {
        home-manager switch --flake ~/.config/home-manager#$env:USERNAME 
    }
}

