#Requires -PSEdition Core

param(
    [Parameter(Mandatory, ValueFromPipeline)]
    [string]$Url,

    [Parameter(Mandatory)]
    [ArgumentCompletions('Librewolf')]
    [string]$BrowserProfile,

    [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
    [string]$Destination = $PWD
)

begin {
    $null = Get-Command yt-dlp -ErrorAction Stop
    $null = Get-Command fzf -ErrorAction Stop
    $sep = [System.IO.Path]::DirectorySeparatorChar

    $cookie = switch ($BrowserProfile) {
        { Test-Path -LiteralPath $_ -PathType Container } {
            $_
            break
        }
        'Librewolf' {
            if ($IsWindows) {
                if (& { scoop prefix librewolf *> $null; 0 -eq $LASTEXITCODE }) {
                    $profileDir = Join-Path (scoop prefix librewolf) 'Profiles'
                    $profiles = Get-ChildItem -Path $profileDir -Directory
                    if ($profiles.Length -gt 1) {
                        $p = $profiles | ForEach-Object FullName | fzf
                        if (!$p) {
                            Write-Error 'fzf: no valid entry selected' -ErrorAction Stop
                        }
                    } else {
                        $p = $profiles | Select-Object -First 1
                    }

                    "firefox:$p"
                } else {
                    Write-Error 'Librewolf detection failed, not installed with scoop.' -ErrorAction Stop
                }
            } else {
                Write-Error 'Librewolf detection for this platform is not implemented yet.' -ErrorAction -Stop
            }
        }
    }

    $tempFile = New-TemporaryFile
}

process {
    "$Url" >> $tempFile
}

end {
    yt-dlp `
        --batch-file $tempFile `
        --cookies-from-browser $cookie `
        -o "$Destination$sep@%(uploader_id)s$sep%(title)s [%(id)s].%(ext)s" `
        --windows-filenames `
        --preset-alias mp4 ` # download mp4 as long as possible, to avoid webm
    $Url
}

clean {
    Remove-Item $tempFile
}
