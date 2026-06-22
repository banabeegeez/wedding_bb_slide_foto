# Mengambil lokasi folder saat ini
$root = Get-Location
$folders = @("LAMARAN", "PEMBERKATAN", "RESEPSI")

foreach ($folder in $folders) {
    $path = Join-Path $root "images\$folder"
    
    if (Test-Path $path) {
        Write-Host "Memproses folder: $folder" -ForegroundColor Cyan
        
        $i = 1
        # Mengambil file gambar (menyesuaikan format bb(n).webp atau sejenisnya)
        $files = Get-ChildItem -Path $path -Filter "*.*" | 
                 Where-Object { $_.Extension -match '\.(jpe?g|png|webp)$' }
        
        foreach ($file in $files) {
            # Membuat nama baru: kategori_0001.webp (padding 4 digit)
            $newName = "$($folder.ToLower())_$($i.ToString('D4'))$($file.Extension.ToLower())"
            
            $targetPath = Join-Path $path $newName
            
            # Melakukan rename
            Rename-Item -Path $file.FullName -NewName $newName
            Write-Host "Diubah: $($file.Name) -> $newName"
            
            $i++
        }
    } else {
        Write-Host "Folder tidak ditemukan: $folder" -ForegroundColor Yellow
    }
}

Write-Host "Selesai! Semua file sudah dirapikan." -ForegroundColor Green