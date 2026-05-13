#Requires -PSEdition Core

# Rename subtitle using the name of video
# video: foo_1080p.mp4
# subtitle: foo.srt -> foo_1080p.srt

[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param(
    [Parameter(Mandatory)]
    [System.IO.FileInfo[]]$Subtitles,
    [Parameter(Mandatory)]
    [System.IO.FileInfo[]]$Videos
)

begin {
    # calculate score of similarity of two names from start
    $calculateScore = {
        param (
            [string]$VideoName,
            [string]$SubtitleName
        )
        $score = 0

        while (
            $score -lt $videoName.Length -and
            $score -lt $subtitleName.Length
        ) {
            if ($videoName[$score] -ne $subtitleName[$score]) {
                break
            }
            $score++
        }

        $score
    }
}

end {
    foreach ($sub in $Subtitles) {
        $video = $Videos
            | Sort-Object {
                & $calculateScore -VideoName $_.Name -SubtitleName $sub.Name
            } -Descending
            | Select-Object -First 1

        $newName = "$($video.BaseName)$($sub.Extension)"
        if ($PSCmdlet.ShouldProcess("Renaming `"$($sub.Name)`" => `"$newName`"", $null, $null)) {
            Rename-Item $sub.FullName $newName
        }
    }
}
