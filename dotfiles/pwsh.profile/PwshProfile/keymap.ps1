$script:braces = ('"', '"'), ("'", "'"), ('(', ')'), ('[', ']'), ('{', '}'), ('<', '>')

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

# conditionally accept when buffer contains newline
Set-PSReadLineKeyHandler -Chord Enter -ScriptBlock {
    $line = $pos = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$pos)

    $inMiddleOfBraces = foreach ($pair in $script:braces) {
        if ($pair[0] -eq $line[$pos - 1] -and $pair[1] -eq $line[$pos]) {
            $true
            break
        }
    }

    if ($line.Contains([System.Environment]::NewLine) -or $inMiddleOfBraces) {
        [Microsoft.PowerShell.PSConsoleReadLine]::AddLine()
        if ($inMiddleOfBraces) {
            [Microsoft.PowerShell.PSConsoleReadLine]::InsertLineAbove()
        }
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}

Set-PSReadLineKeyHandler -Chord 'Ctrl+Enter' -Function AcceptLine

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
Set-PSReadLineKeyHandler -Chord 'y,x' -ViMode Command -ScriptBlock {
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

Set-PSReadLineKeyHandler -Chord 'y,y' -ViMode Command -ScriptBlock {
    $line = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$null)
    if ($env:WSL_DISTRO_NAME) {
        if (Get-Command win32yank.exe -ErrorAction SilentlyContinue -OutVariable clip) {
            $line | & $clip -i
        } else {
            [System.Console]::Beep()
        }
    } else {
        Set-Clipboard $line
    }
}

foreach ($brace in $script:braces) {
    Set-PSReadLineKeyHandler -Chord $brace[0] -ScriptBlock {
        # NOTE: $pos is 1-based length of the line
        $line = $pos = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$pos)

        if (
            ($pos -ne $line.Length) -and # not at the end of line
            ($line[$pos] -ne ' ') -and # not next to a real char
            ($line[$pos] -ne $brace[1]) -and # not next to closing brace
            ($line[$pos] -ne [Environment]::NewLine) # not next to newline on multi-line editing
        ) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($brace[0])
        } elseif ($brace[0] -ne $brace[1]) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($brace[0])
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($brace[1])
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($pos + 1)
        } else {
            $left = $pos - 1
            $right = $pos
            if ($line[$left] -eq $brace[0] -and $line[$right] -eq $brace[1] ) {
                [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($right + 1)
            } else {
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert($brace[0])
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert($brace[1])
                [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($pos + 1)
            }
        }
    }.GetNewClosure()

    if ($brace[0] -ne $brace[1]) {
        Set-PSReadLineKeyHandler -Chord $brace[1] -ScriptBlock {
            $line = $pos = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$pos)
            $left = $pos - 1
            $right = $pos
            if ($line[$left] -eq $brace[0] -and $line[$right] -eq $brace[1] ) {
                [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($right + 1)
            } else {
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert($brace[1])
                [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($pos + 1)
            }
        }.GetNewClosure()
    }
}

Set-PSReadLineKeyHandler -Key Backspace -ScriptBlock {
    $line = $pos = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$pos)

    $deleted = $false
    foreach ($brace in $script:braces) {
        $left = $pos - 1
        $right = $pos
        if ($line[$left] -eq $brace[0] -and $line[$right] -eq $brace[1] ) {
            [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar()
            # NOTE: cursor position would change after deletion
            # now right brace is on the position of previous/deleted left
            # so we need to go back to original right position
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($right)
            [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar()
            $deleted = $true
            break
        }
    }
    if (-not $deleted) {
        [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar()
    }
}

Set-PSReadLineKeyHandler -Chord ' ,p' -ViMode Command -ScriptBlock {
    $line = $pos = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$pos)

    if ($line.Length -ne 0) {
        # NOTE: increment cursor position so it would paste like in vim
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(' ')
        [Microsoft.PowerShell.PSConsoleReadLine]::ForwardChar()
    }

    if ($env:WSL_DISTRO_NAME) {
        if (Get-Command win32yank.exe -ErrorAction SilentlyContinue -OutVariable clip) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert((& $clip -o --lf))
        } else {
            [System.Console]::Beep()
        }
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert((Get-Clipboard -Raw))
    }
}

Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
