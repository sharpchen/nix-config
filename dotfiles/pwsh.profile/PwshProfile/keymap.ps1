Set-PSReadLineOption -EditMode Vi

Set-PSReadLineKeyHandler -Key 'Ctrl+ ' -Function MenuComplete -ViMode Insert
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key 'Ctrl+p' -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key 'Ctrl+n' -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord 'g,h' -Function GotoFirstNonBlankOfLine -ViMode Command
Set-PSReadLineKeyHandler -Key Tab -Function ViGotoBrace -ViMode Command
Set-PSReadLineKeyHandler -Key Y -Function ViYankToEndOfLine -ViMode Command
Set-PSReadLineKeyHandler -Chord 'g,l' -Function MoveToEndOfLine -ViMode Command
Set-PSReadLineKeyHandler -Chord ' ,z' -ViMode Command -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::GotoFirstNonBlankOfLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('(')
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(')')
    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardChar()
}
Set-PSReadLineKeyHandler -Chord ' ,Z' -ViMode Command -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('(')
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(')')
    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardChar()
}
Set-PSReadLineKeyHandler -Chord ' , ' -ViMode Command -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar()
    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardWord()
    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteWord()
}
Set-PSReadLineKeyHandler -Chord 'y,y' -ViMode Command -ScriptBlock {
    if ($env:WSL_DISTRO_NAME) {
        if (Get-Command win32yank.exe -ErrorAction SilentlyContinue -OutVariable clip) {
            $PWD.Path | & $clip -i
        } else {
            [System.Console]::Beep()
        }
    } else {
        Set-Clipboard $PWD
    }
}

Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
