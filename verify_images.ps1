$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $root
$folders = @('images','images\LAMARAN','images\PEMBERKATAN','images\RESEPSI')
$result = @()
foreach ($folder in $folders) {
    $files = Get-ChildItem -Path $folder -File -ErrorAction SilentlyContinue
    $count = $files.Count
    $newPattern = $files | Where-Object { $_.Name -match '^(lamaran|pemberkatan|resepsi)_\d{4}\.webp$' }
    $oldPattern = $files | Where-Object { $_.Name -match '^bb \(\d+\)\.webp$' }
    $result += [pscustomobject]@{
        Folder = $folder
        TotalFiles = $count
        NewPattern = $newPattern.Count
        OldPattern = $oldPattern.Count
        NewSample = $newPattern | Select-Object -First 5 -ExpandProperty Name
        OldSample = $oldPattern | Select-Object -First 5 -ExpandProperty Name
    }
}
$result | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath verify_images_result.json -Encoding UTF8
Write-Host 'DONE'