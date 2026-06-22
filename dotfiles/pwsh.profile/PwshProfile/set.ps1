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
        '^\s*&?\s+\b(?:aria2c|sioyek)\b(\.exe)?' {
            $false
        }
        default {
            $true
        }
    }
}

$global:PSDefaultParameterValues = @{
    'Update-Help:UICulture'            = 'en-US'
    'Update-Help:ProgressAction'       = 'SilentlyContinue'
    'Invoke-WebRequest:ProgressAction' = 'SilentlyContinue'
    'Clear-RecycleBin:ProgressAction'  = 'SilentlyContinue'
}

# Set-PSReadLineOption -PredictionViewStyle ListView
