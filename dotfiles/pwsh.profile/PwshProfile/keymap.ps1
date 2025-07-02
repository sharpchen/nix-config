Set-PSReadLineOption -EditMode Vi

Set-PSReadLineKeyHandler -Key 'Ctrl+ ' -Function MenuComplete
Set-PSReadLineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key 'Ctrl+p' -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key 'Ctrl+n' -Function HistorySearchForward
Set-PSReadLineKeyHandler -Chord 'g,h' -Function GotoFirstNonBlankOfLine -ViMode Command
Set-PSReadLineKeyHandler -Chord Tab -Function GotoBrace -ViMode Command
Set-PSReadLineKeyHandler -Chord 'g,l' -Function EndofLine -ViMode Command
Set-PSReadLineKeyHandler -Chord ' ,z' -ViMode Command -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::GotoFirstNonBlankOfLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('(')
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(')')
}
Set-PSReadLineKeyHandler -Chord ' ,Z' -ViMode Command -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('(')
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(')')
}
Set-PSReadLineKeyHandler -Chord ' , ' -ViMode Command -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar()
    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardWord()
    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteWord()
}

Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
