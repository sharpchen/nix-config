function pinfo {
    param (
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [ValidateScript({ Get-Command $_ -ErrorAction Ignore })]
        [string]$Command,
        [switch]$Positional,
        [switch]$Pipeline,
        [switch]$Alias,
        [switch]$Mandatory,
        [switch]$ParameterType,
        [switch]$All,

        [ArgumentCompleter({
                param (
                    $commandName,
                    $parameterName,
                    $wordToComplete,
                    $commandAst,
                    $fakeBoundParameters
                )

                if ($fakeBoundParameters.ContainsKey('Command')) {
                    $cmd = Get-Command $fakeBoundParameters['Command']
                    if ($cmd -is [System.Management.Automation.AliasInfo]) {
                        $cmd = Get-Command $cmd.Definition
                    }
                    $cmd.ParameterSets.Name
                }
            })]
        [Parameter(ParameterSetName = 'ParameterSet')]
        [string]$ParameterSet
    )

    begin {
        $cmd = Get-Command $Command
        if ($cmd -is [System.Management.Automation.AliasInfo]) {
            $cmd = Get-Command $cmd.Definition
        }
        $eachSet = @()
        $CommonParams = @(
            'Verbose',
            'Debug',
            'ErrorAction',
            'WarningAction',
            'InformationAction',
            'ProgressAction',
            'ErrorVariable',
            'WarningVariable',
            'InformationVariable',
            'OutVariable',
            'OutBuffer',
            'PipelineVariable',
            'WhatIf',
            'Confirm'
        )
    }

    end {
        if ($ParameterSet) {
            $parameterSets = $cmd.ParameterSets | Where-Object Name -EQ $ParameterSet
        } else {
            $parameterSets = $cmd.ParameterSets
        }
        foreach ($pset in $parameterSets) {
            $childParameters = [System.Collections.Generic.List[pscustomobject]]@()
            $pset.Parameters | Where-Object { $_.Name -notin $CommonParams } |
                ForEach-Object {
                    $name, $attr = $_.Name, $_.Attributes
                    $pipe = @()
                    $paramInfo = [pscustomobject]@{
                        Name         = $name
                        ParameterSet = "$($cmd.Name)::$($pset.Name)"
                    }

                    if ($Pipeline -or $All) {
                        if ($attr.ValueFromPipeline) {
                            $pipe += 'Value'
                        }
                        if ($attr.ValueFromPipelineByPropertyName) {
                            $pipe += 'Property'
                        }
                        $paramInfo | Add-Member -MemberType NoteProperty -Name Pipeline -Value $pipe
                    }
                    # MinValue meaning Position attribute is not assigned
                    if ($All -or $Positional -and $attr.Position -ne [int]::MinValue) {
                        $paramInfo | Add-Member -MemberType NoteProperty -Name Position -Value $attr.Position
                    }
                    if ($Alias -or $All) {
                        $paramInfo | Add-Member -MemberType NoteProperty -Name Alias -Value $attr.AliasNames
                    }
                    if (($Mandatory -or $All) -and $attr.Mandatory) {
                        $paramInfo | Add-Member -MemberType NoteProperty -Name Mandatory -Value $attr.Mandatory
                    }
                    if ($ParameterType -or $All) {
                        $paramInfo | Add-Member -MemberType NoteProperty -Name ParameterType -Value $_.ParameterType.FullName
                    }

                    $childParameters.Add($paramInfo)
                }

            $eachSet += $childParameters
        }
        $format = @{
            Property = @(
                @{ Name = 'Parameter'; Expression = { $_.Name } }
                if ($Positional -or $All) {
                    @{ Name = 'Position'; Expression = { $_.Position } }
                }
                if ($Mandatory -or $All) {
                    @{ Name = 'Mandatory'; Expression = { $_.Mandatory } }
                }
                if ($Pipeline -or $All) {
                    @{ Name = 'Pipeline'; Expression = { $_.Pipeline -join ', ' } }
                }
                if ($Alias -or $All) {
                    @{ Name = 'Alias'; Expression = { $_.Alias -join ', ' } }
                }
                if ($ParameterType -or $All) {
                    @{ Name = 'ParameterType'; Expression = { $_.ParameterType } }
                }
            )
        }
        $eachSet | ForEach-Object { $_ } | Format-Table @format -GroupBy ParameterSet -AutoSize
    }
}

function play {
    [CmdletBinding(DefaultParameterSetName = '__AllParameterSets')]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [Alias('FullName')]
        [string]$LiteralPath,

        [Parameter(ParameterSetName = 'ByDate')]
        [switch]$ByDate
    )

    begin {
        $null = Get-Command mpv -ErrorAction Stop
        $playlist = [System.Collections.Generic.List[string]]::new()
    }

    process {
        $playlist.Add($LiteralPath)
    }

    end {
        if ($MyInvocation.ExpectingInput) {
            if ($ByDate) {
                $playlist = $playlist | Sort-Object { (Get-Item -LiteralPath $_).CreationTime } -Descending
            }
            $null = Start-Job { $input | mpv --force-window --playlist=- } -InputObject $playlist
        } else {
            $null = Start-Job { mpv --force-window $args } -ArgumentList $LiteralPath
        }
    }
}

function dnpack {
    begin {
        $null = Get-Command dotnet -ErrorAction Stop
        $null = Get-Command fzf -ErrorAction Stop
        $null = Get-Command tr -ErrorAction Stop
    }

    end {
        $res = dotnet package search @args --format json | ConvertFrom-Json

        $res.searchResult.packages |
            ForEach-Object { "$($_.id)`tLatest Version: $($_.latestVersion)`tTotal Downloads: $($_.totalDownloads)`tOwners: $($_.owners)" } |
            fzf  --delimiter='\t' `
                --with-nth=1 `
                --preview-window=down `
                --preview='echo {2..} | tr "\t" "\n"' `
                --bind 'enter:execute(dotnet add package {1})+abort'
    }
}

function pmclean {
    param (
        [ValidateSet('scoop', 'npm', 'nuget', 'nix')]
        [Parameter(Position = 1)]
        [string]$PackageManager
    )

    switch -Exact ($PackageManager) {
        'scoop' {
            $null = Get-Command scoop -ErrorAction Stop
            scoop cleanup *
            scoop cache rm *
        }
        'nuget' {
            $null = Get-Command dotnet -ErrorAction Stop
            dotnet nuget locals all --clear
        }
        'npm' {
            $null = Get-Command npm -ErrorAction Stop
            npm cache clean --force
        }
        'pnpm' {
            $null = Get-Command pnpm -ErrorAction Stop
            pnpm store prune
        }
        'nix' {
            $null = Get-Command nh -ErrorAction Stop
            nh clean all
        }
    }
}

function p {
    begin {
        $null = Get-Command fzf -ErrorAction Stop
    }
    end {
        $folders = @(Get-ChildItem '~/projects' -Directory)
        if (Test-Path '~/.config/home-manager/') {
            $folders += Get-Item '~/.config/home-manager/'
        }
        $dest = $folders | ForEach-Object FullName | fzf
        if ($dest) {
            Push-Location
            Set-Location $dest
        }
    }
}

function ds {
    [CmdletBinding(DefaultParameterSetName = 'Directory')]
    param (
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
        [Parameter(Position = 0, ParameterSetName = 'Directory')]
        [string]$Dir,

        [ValidateSet('kb', 'mb', 'gb')]
        [string]$Unit,

        [Parameter(ValueFromPipelineByPropertyName, ValueFromPipeline, ParameterSetName = 'Pipeline')]
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
        [Alias('FullName')]
        [string]$InputObject
    )
    begin {
        $du = Get-Command du -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not $Dir) {
            $Dir = $PWD.Path
        }
        $length = 0
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'Pipeline' {
                if ($du) {
                    $length += (((& $du -L --bytes --total --summarize $InputObject)[-1] -split '\s+')[0]) -as [long]
                } else {
                    $length += (Get-Item $InputObject).Length
                }
            }
        }
    }

    end {
        switch ($PSCmdlet.ParameterSetName) {
            'Directory' {
                if ($du) {
                    $length = (((& $du[0] -L --bytes --total --summarize $Dir)[-1] -split '\s+')[0]) -as [long]
                } else {
                    $length = (Get-ChildItem -File -Force -Recurse -LiteralPath $Dir | Measure-Object Length -Sum).Sum
                }
            }
        }

        switch ($Unit) {
            'kb' {
                $length / 1kb
            }
            'mb' {
                $length / 1mb
            }
            'gb' {
                $length / 1gb
            }
            default {
                $length
            }
        }
    }
}

function any {
    param (
        [Parameter(ValueFromPipeline)]
        [psobject]$InputObject,
        [Parameter(Position = 1)]
        [scriptblock]$Condition
    )

    process {
        if (
            $Condition -and
            $Condition.InvokeWithContext($null, [psvariable]::new('_', $_)) -or
            $_ # nullable | any
        ) {
            $true
            # FIXME: break skips `end` block
            # https://github.com/PowerShell/PowerShell/issues/27389
            break
        }
    }

    end {
        $false
    }
}

function all {
    param (
        [Parameter(ValueFromPipeline)]
        [psobject]$InputObject,
        [Parameter(Position = 1, Mandatory)]
        [scriptblock]$Condition
    )

    process {
        if (-not $Condition.InvokeWithContext($null, [psvariable]::new('_', $_))) {
            $false
            # FIXME: break skips `end` block
            # https://github.com/PowerShell/PowerShell/issues/27389
            break
        }
    }

    end {
        $true
    }
}

function exclude {
    param (
        [Parameter(ValueFromPipeline)]
        [psobject]$InputObject,

        [Parameter(Position = 1, Mandatory)]
        [psobject]$Exclude
    )

    begin {
        $excludeFilter = $Exclude -is [scriptblock]
    }

    process {
        if ($excludeFilter) {
            if (-not $Exclude.InvokeWithContext($null, [psvariable]::new('_', $_))) {
                $_
            }
        } else {
            if ($_ -cnotin $Exclude) {
                $_
            }
        }
    }
}

function reverse {
    param (
        [Parameter(ValueFromPipeline)]
        [psobject]$InputObject
    )

    for ($i = $input.Count - 1; $i -ge 0 ; $i--) {
        $input[$i]
    }
}

function string {
    [CmdletBinding(DefaultParameterSetName = 'FormatSpecifier')]
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject,

        [Parameter(Position = 0, ParameterSetName = 'FormatSpecifier')]
        [string]$FormatSpecifier,

        [Parameter(ParameterSetName = 'Format')]
        [string]$Format
    )

    begin {
        $ErrorActionPreference = 'Stop'
    }

    process {
        switch($PSCmdlet.ParameterSetName) {
            FormatSpecifier {
                if ($PSBoundParameters.ContainsKey('FormatSpecifier')) {
                    $InputObject.ToString($FormatSpecifier)
                } else {
                    $InputObject.ToString()
                }
            }
            Format {
                $Format -f $InputObject
            }
        }
    }
}

function int {
    process {
        [int]$_
    }
}

function char {
    process {
        [char]$_
    }
}

if (Test-Path alias:type) {
    Remove-Item alias:type
}
function type {
    process {
        $_.GetType()
    }
}

function typename {
    process {
        $_.GetType().FullName
    }
}

function default {
    param(
        [Parameter(ValueFromPipeline)]
        $InputObject,
        [Parameter(Mandatory, Position = 0)]
        $Default
    )
    process {
        if ($null -eq $_) {
            $Default
        } else {
            $_
        }
    }
}

function get {
    param(
        [Parameter(Position = 0, Mandatory)]
        [string]$PropertyPath,
        [Parameter(ValueFromPipeline, Mandatory)]
        [psobject]$InputObject
    )
    begin {
        $propertyNames = $PropertyPath -split '\.'
    }

    process {
        $val = $InputObject

        $count = 0
        while (
            $count -lt $propertyNames.Count -and
            $null -ne ($prop = $val."$($propertyNames[$count])")
        ) {
            if ($propertyNames[$count] -eq 'GetType') {
                $val = $val.GetType()
            } elseif ($prop -is [System.Management.Automation.PSMethod]) {
                $val = $prop.Invoke()
            } else {
                $val = $prop
            }
            $count++
        }
        # return only when the whole path was enumerated
        if ($count -eq $propertyNames.Length) {
            $val
        }
    }
}

function epubpack {
    param (
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
        [Parameter(Position = 0, Mandatory)]
        [string]$Folder,
        [Parameter(Position = 1)]
        [ValidateScript({ Test-Path -IsValid $_ })]
        [string]$OutFile
    )

    begin {
        $zip = Get-Command zip -CommandType Application -ErrorAction Stop
        $null = Get-Item (Join-Path $Folder 'mimetype') -ErrorAction Stop
        $output = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutFile)
        # NOTE: delete if file already exist, otherwise zip would silently *append* contents to it.
        if (Test-Path $output) {
            Remove-Item $output -Confirm
        }
    }

    end {
        $parameters = @{
            FilePath         = $zip.Source
            WorkingDirectory = Resolve-Path $Folder
            ArgumentList     = "-Xr9Dq $output mimetype *"
        }

        Start-Process @parameters -Wait -NoNewWindow -UseNewEnvironment
    }
}

# TODO: support encrypted archive
function unpack {
    # NOTE: to enforce pwsh accept a shorter syntax
    # __AllParameterSets can be a arbitrary name other than defined ParameterSetNames
    [CmdletBinding(DefaultParameterSetName = '__AllParameterSets')]
    param (
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Leaf })]
        [Parameter(Position = 0, Mandatory)]
        [string]$LiteralPath,

        [ValidateScript({ Test-Path $_ -IsValid })]
        [Parameter(Position = 1, ParameterSetName = 'Destination')]
        [string]$Destination,

        [Parameter(ParameterSetName = 'Direct')]
        [switch]$Direct
    )
    begin {
        $tar = Get-Command bsdtar -ErrorAction Stop
    }

    end {
        switch ($PSCmdlet.ParameterSetName) {
            'Direct' {
                & $tar xf $LiteralPath --cd $PWD
            }
            'Destination' {
                if (-not (Test-Path $Destination)) {
                    $null = New-Item -ItemType Directory -Path $Destination
                }

                & $tar xf $LiteralPath --cd $Destination

                if ($LASTEXITCODE -ne 0) {
                    Remove-Item $Destination -Recurse -Force
                }
            }
            default {
                $rootEntries = 0
                $prevFirstSegment = $null
                $null = & $tar tf $LiteralPath |
                    Where-Object { $_ -ne './' } |
                    ForEach-Object {
                        # two kinds of folders tar can list, depending on how the archive was created
                        # - Explicit Folder: ./foo/, foo/bar/ etc.
                        # - Implicit Folder: foo/bar/file.txt etc.
                        $normalized = $_ -replace '^\./', '' # trim leading portion if relative
                        # get the first segment of the path, which is either the topmost container name or the filename itself at root
                        # file at root: <filename>
                        # sub path: <name>/foo/bar/[file]
                        $currentFirstSegment = ($normalized -split '/', 2)[0]
                        if ($currentFirstSegment -ne $prevFirstSegment) {
                            $rootEntries++
                            $prevFirstSegment = $currentFirstSegment
                        }
                        # NOTE: you can't break inside ForEach-Object when source come from native command
                        # see: https://github.com/PowerShell/PowerShell/issues/26662
                        if ($rootEntries -gt 1) {
                            $true # pipe a non-null value so that Select-Object can capture
                        }
                    } | Select-Object -First 1 # terminate pipeline early

                if ($rootEntries -gt 1) {
                    $basename = (Get-Item $LiteralPath).BaseName
                    if (-not (Test-Path $basename -PathType Container)) {
                        $null = New-Item -ItemType Directory -Path $basename
                    }
                    & $tar xf $LiteralPath --cd $basename
                } else {
                    & $tar xf $LiteralPath --cd $PWD
                }
            }
        }
    }
}

function cptree {
    param (
        [Alias('Root')]
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
        [Parameter(Position = 0, Mandatory)]
        [string]$LiteralPath,
        [ValidateScript({ Test-Path -LiteralPath $_ -PathType Container })]
        [Parameter(Position = 1, Mandatory)]
        [string]$Destination,
        [switch]$ExcludeRoot,
        [switch]$Force
    )

    begin {
        $root = Convert-Path $LiteralPath
        $dest = Convert-Path $Destination
        if (-not $ExcludeRoot) {
            $dest = Join-Path $dest (Split-Path $root -Leaf)
        }
    }

    end {
        $null = Get-ChildItem -Path $root -Directory -Recurse -Force:$Force |
            Resolve-Path -Relative -RelativeBasePath $root |
            ForEach-Object { [pscustomobject]@{ Path = Join-Path $dest $_ } } | # NOTE: wrap it as Path property, New-Item requires to do so
            New-Item -ItemType Directory
    }
}

function dbconnectstr {
    param (
        [ValidateSet('postgres')]
        [string]$Driver,
        [string]$UserName,
        [string]$DriverHost = 'localhost',
        [ushort]$Port = 5432
    )

    begin {
        if (-not $Driver) {
            $null = Get-Command fzf -ErrorAction Stop
            $Driver = 'postgres' | fzf --prompt 'Pick database engine'
        }
        if (-not $UserName) {
            $UserName = Read-Host -Prompt 'UserName'
            if (-not $UserName) {
                $UserName = switch($Driver) {
                    'postgres' {
                        'postgres'
                    }
                }
            }
        }
        $database = Read-Host -Prompt 'Datebase'
        $password = Read-Host -Prompt 'Password' -MaskInput
    }
    end {
        switch($Driver) {
            'postgres' {
                "postgres://$($UserName):$($password)@$($DriverHost):$($Port)/$($database)"
            }
        }
    }
}

function connectdb {
    begin {
        $null = Get-Command sqlit -ErrorAction Stop
    }

    end {
        sqlit (dbconnectstr)
    }
}

function pubip {
    try {
        (Invoke-WebRequest myip.90daili.com).Content |
            Select-String '\b[0-9\.]+\b' |
            ForEach-Object { $_.Matches[0].Value }
    } catch {
        (Invoke-WebRequest -Uri 'https://api.ipify.org/').Content
    }
}

function hisdel {
    param(
        [Parameter(Mandatory)]
        [string]$Pattern,
        [switch]$Escape
    )

    begin {
        $count = 0
        $history = (Get-PSReadLineOption).HistorySavePath
        $filtered = [System.Collections.Generic.List[string]]::new()
        if ($Escape) {
            $Pattern = [regex]::Escape($Pattern)
        }
    }
    end {
        switch -Regex -File $history {
            $pattern {
                $count++
            }
            default {
                $filtered.Add($_)
            }
        }
        Set-Content -Path $history -Value $filtered
        Write-Host "hisdel: $count entries deleted." -ForegroundColor Yellow
    }
}

function ydl {
    [CmdletBinding(DefaultParameterSetName = '__AllParameterSets')]
    param (
        [Parameter(Mandatory, Position = 1)]
        [string]$Url,

        [string]$Format,

        [Parameter(ParameterSetName = 'ListDetails')]
        [switch]$ListDetails,

        [Parameter(ParameterSetName = 'ListFormats')]
        [switch]$ListFormats,

        [switch]$AudioOnly,

        [switch]$PassThru
    )

    begin {
        $ydl = Get-Command yt-dlp -ErrorAction Stop
        $flags = @()
        if ($Format) {
            $flags += '-f', $Format
        }
        if ($AudioOnly) {
            $flags += '--extract-audio'
        }
        if (Get-Command aria2c -ErrorAction Ignore) {
            $flags += '--downloader', 'aria2c'
        }
        if (Get-Command deno -ErrorAction Ignore) {
            $flags += '--js-runtimes', 'deno'
        } elseif (Get-Command bun -ErrorAction Ignore) {
            $flags += '--js-runtimes', 'bun'
        } elseif (Get-Command node -ErrorAction Ignore) {
            $flags += '--js-runtimes', 'node'
        }
    }

    end {
        switch ($PSCmdlet.ParameterSetName) {
            ListFormats {
                $result = & $ydl -q --dump-json --compat-options manifest-filesize-approx $Url |
                    ConvertFrom-Json |
                    Select-Object -ExpandProperty formats |
                    Select-Object format_id,
                    @{ name = 'filesize'; expr = { __humanize-size $_.filesize_approx } },
                    ext, resolution, fps, protocol, vcodec, acodec, language

                if ($PassThru) {
                    $result
                } else {
                    $result | Format-Table
                }
            }
            ListDetails {
                $template = [ordered]@{
                    Id            = '%(id)s'
                    Title         = '%(title)s'
                    Uploader      = '%(uploader)s'
                    'Upload Date' = '%(upload_date)s'
                    Views         = '%(view_count)s'
                    Description   = '%(description)s'

                    Size          = '%(filesize_approx)#.2DB'
                    Duration      = '%(duration_string)s'
                    Resolution    = '%(resolution)s'
                    'Format ID'   = '%(format_id)s' # default format_id picked
                }
                & $ydl --simulate --print (ConvertTo-Json $template) $Url | ConvertFrom-Json
            }
            default {
                & $ydl @flags $Url
            }
        }
    }
}

function __humanize-size {
    param([long]$Bytes)

    switch ($Bytes) {
        { $_ -ge 1TB } {
            '{0:N2} TB' -f ($Bytes / 1TB)
            break
        }
        { $_ -ge 1GB } {
            '{0:N2} GB' -f ($Bytes / 1GB)
            break
        }
        { $_ -ge 1MB } {
            '{0:N2} MB' -f ($Bytes / 1MB)
            break
        }
        { $_ -ge 1KB } {
            '{0:N2} KB' -f ($Bytes / 1KB)
            break
        }
        default {
            "$Bytes Bytes"
        }
    }
}

function title {
    $Host.UI.RawUI.WindowTitle = $args
}

function distinct {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject]$InputObject,
        [Parameter(Position = 0)]
        [object]$Property
    )

    begin {
        $sort = { Sort-Object $Property -Unique }.GetSteppablePipeline($MyInvocation.CommandOrigin)
        $sort.Begin($PSCmdlet)
    }

    process {
        $sort.Process($InputObject)
    }

    end {
        $sort.End()
    }
}

function not {
    process {
        -not $_
    }
}

function rand {
    param(
        [Alias('n')]
        [uint]$Count
    )
    if ($PSBoundParameters.ContainsKey('Count')) {
        $input | Sort-Object { Get-Random } | Select-Object -First $Count
    } else {
        $input | Sort-Object { Get-Random }
    }
}

function pow {
    param(
        [Parameter(Mandatory, Position = 0)]
        $Base,
        [Parameter(Mandatory, Position = 1)]
        $Power
    )

    [System.Math]::Pow($Base, $Power)
}

function expand {
    $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($args[0])
}

function replace {
    param(
        [Parameter(ValueFromPipeline)]
        [string]$InputObject,

        [Parameter(Position = 0)]
        [string]$Pattern,

        [Parameter(Position = 1)]
        [string]$Replace,

        [ValidateScript({ $_ -gt 0 })]
        [Alias('n')]
        [int]$Count,

        [Alias('c')]
        [switch]$CaseSensitive,

        [Alias('l')]
        [switch]$Literal
    )

    begin {
        if ($Literal) {
            $Pattern = [regex]::Escape($Pattern)
        }
        if ($CaseSensitive) {
            $regex = [regex]::new($Pattern)
        } else {
            $regex = [regex]::new($Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        }
    }

    process {
        if ($PSBoundParameters.ContainsKey('Count')) {
            $regex.Replace($InputObject, $Replace, $Count)
        } else {
            $regex.Replace($InputObject, $Replace)
        }
    }
}
