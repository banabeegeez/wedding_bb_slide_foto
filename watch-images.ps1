# Watch the images folder and automatically update image-files.txt when .webp files change.
# Run this in PowerShell while you work on the project.

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$imagesFolder = Join-Path $projectRoot 'images'
$manifestFile = Join-Path $projectRoot 'image-files.txt'

function Update-ImageManifest {
    $files = Get-ChildItem -LiteralPath $imagesFolder -Recurse -File |
        Where-Object { $_.Extension -match '^(?:\.jpe?g|\.png|\.webp|\.gif)$' -and $_.Name -ne 'cover.webp' }

    $manifestEntries = $files |
        Select-Object -Property *,
            @{Name='RelativePath';Expression={
                $_.FullName.Substring($imagesFolder.Length + 1).TrimStart('\').Replace('\','/')
            }},
            @{Name='RelativeFolder';Expression={
                $relative = $_.FullName.Substring($imagesFolder.Length + 1).TrimStart('\')
                (Split-Path $relative -Parent).Replace('\','/')
            }},
            @{Name='SortNumber';Expression={
                $match = [regex]::Match($_.BaseName, '\d+')
                if ($match.Success) { [int]$match.Value } else { 0 }
            }} |
        Sort-Object RelativeFolder, SortNumber, Name |
        Select-Object -ExpandProperty RelativePath

    $manifestEntries | Set-Content -LiteralPath $manifestFile -Encoding UTF8
    Write-Host "Updated image manifest at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
}

Update-ImageManifest

$watcher = New-Object System.IO.FileSystemWatcher $imagesFolder, '*.*'
$watcher.IncludeSubdirectories = $false
$watcher.EnableRaisingEvents = $true

$action = {
    Start-Sleep -Milliseconds 200
    Update-ImageManifest
}

Register-ObjectEvent $watcher Created -Action $action | Out-Null
Register-ObjectEvent $watcher Deleted -Action $action | Out-Null
Register-ObjectEvent $watcher Renamed -Action $action | Out-Null
Register-ObjectEvent $watcher Changed -Action $action | Out-Null

Write-Host "Watching '$imagesFolder' for .webp file changes. Press Ctrl+C to stop."

while ($true) {
    Start-Sleep -Seconds 1
}
