if ($Host.Name -ne 'ConsoleHost') {
    Write-Information 'Current Host is not ConsoleHost'
    return
}

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

$PSStyle.FileInfo.Directory = $PSStyle.Foreground.BrightBlue + $PSStyle.Bold

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
