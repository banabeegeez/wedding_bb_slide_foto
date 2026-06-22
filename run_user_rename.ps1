$root = Get-Location
$folders = @("LAMARAN", "PEMBERKATAN", "RESEPSI")

foreach ($folder in $folders) {
    $path = Join-Path $root "images\$folder"
    if (Test-Path $path) {
        $files = Get-ChildItem $path -Filter "bb (*).webp"
        foreach ($file in $files) {
            # Mengubah "bb (123).webp" menjadi "bb_0123.webp"
            $number = [regex]::Match($file.Name, '\d+').Value
            $newName = "$($folder.ToLower())_$($number.PadLeft(4, '0')).webp"
            Rename-Item -Path $file.FullName -NewName $newName
        }
    }
}
