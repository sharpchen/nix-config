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

$script:braces = ('"', '"'), ("'", "'"), ('(', ')'), ('[', ']'), ('{', '}'), ('<', '>')

foreach ($brace in $braces) {
    Set-PSReadLineKeyHandler -Chord $brace[0] -ScriptBlock {
        $line = $pos = $null
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$pos)

        if ($brace[0] -ne $brace[1]) {
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
    foreach ($brace in $braces) {
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
}.GetNewClosure()

Set-PSReadLineKeyHandler -Chord ' ,p' -ViMode Command -ScriptBlock {
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
