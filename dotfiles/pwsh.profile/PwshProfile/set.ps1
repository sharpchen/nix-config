if ($IsLegacy) {
    Set-PSReadLineOption -ViModeIndicator Prompt
}

if ($IsCoreCLR) {
    # PowerShell Desktop does not have $PSStyle
    $PSStyle.FileInfo.Directory = $PSStyle.Foreground.BrightBlue + $PSStyle.Bold

    Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler {
        if ($args[0] -eq 'Command') {
            # Set the cursor to a blinking block.
            Write-Host -NoNewline "`e[2 q"
        } else {
            # Set the cursor to a blinking line.
            Write-Host -NoNewline "`e[5 q"
        }
    }
}

Set-PSReadLineOption -Colors @{
    Parameter = [System.ConsoleColor]::Magenta
    Operator  = [System.ConsoleColor]::Cyan
    Type      = [System.ConsoleColor]::Cyan
    Keyword   = [System.ConsoleColor]::Magenta
    Command   = [System.ConsoleColor]::Blue
    Number    = [System.ConsoleColor]::Yellow
    Member    = [System.ConsoleColor]::Red
    String    = [System.ConsoleColor]::Green
    Variable  = [System.ConsoleColor]::DarkGreen
}

Set-PSReadLineOption -AddToHistoryHandler {
    param($history)

    switch -Regex ($history) {
        '\b(?:aria2c|rainfrog|sioyek)\b(\.exe)?' {
            $false
        }
        default {
            $true
        }
    }
}

$global:PSDefaultParameterValues = @{
    'Update-Help:UICulture' = 'en-US'
}

function prompt {
    $left = "`e[1;32m"
    $right = "`e[0m"
    if ($IsLinux -or $IsMacOS) {
        $ps1 = "PS $($pwd.ProviderPath -replace '/home/[a-zA-Z0-9]+', '~')$('>' * ($nestedPromptLevel + 1)) "
    } else {
        $pattern = 'C:\\Users\\[a-zA-Z0-9]+'
        $path = if ($pwd.ProviderPath -match $pattern) {
            "~$($pwd.ProviderPath -replace $pattern, [string]::Empty)"
        } else {
            $pwd.ProviderPath
        }
        $ps1 = "PS $path$('>' * ($nestedPromptLevel + 1)) "
    }
    if ($PSVersionTable.PSEdition -eq 'Core') {
        return $left + $ps1 + $right
    } else {
        return $ps1
    }
}

# Set-PSReadLineOption -PredictionViewStyle ListView
