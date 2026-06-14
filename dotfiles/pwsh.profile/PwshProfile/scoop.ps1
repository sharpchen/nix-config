if (Get-Command scoop -ErrorAction Ignore) {
    if (& { scoop prefix sioyek *> $null; 0 -eq $LASTEXITCODE }) {
        function sioyek {
            & (Join-Path (scoop prefix sioyek) 'sioyek.exe') @args
        }
    }

    if (& { scoop prefix git *> $null; 0 -eq $LASTEXITCODE }) {
        function file {
            & (Join-Path (scoop prefix git) 'usr\bin\file.exe') @args
        }
    }

    if (& { scoop prefix scoop-completion *> $null; 0 -eq $LASTEXITCODE }) {
        Import-Module (Join-Path (scoop prefix scoop-completion) 'scoop-completion.psd1')
    }
}
