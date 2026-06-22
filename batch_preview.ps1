$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $projectRoot
$hasMagick = (Get-Command magick -ErrorAction SilentlyContinue) -ne $null
$hasCwebp = (Get-Command cwebp -ErrorAction SilentlyContinue) -ne $null
$files = Get-ChildItem -Path .\images -File | Where-Object { $_.Name -ne 'cover.webp' -and $_.Name -notmatch '^bb \((\d+)\)\.webp$' } | Select-Object Name,Extension
$result = @{ magick = $hasMagick; cwebp = $hasCwebp; files = $files }
$result | ConvertTo-Json -Depth 3
