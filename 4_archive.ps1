$exceptions = @('377163','393883','393884')

if (-not (Test-Path -Path '.\output')) { New-Item -Path '.\output' -ItemType Directory | Out-Null }

Get-ChildItem -Path '.\depots' -Directory | ForEach-Object {
    $depotId = $_.Name

    # skip exceptions
    if ($exceptions -contains $depotId) {
        Write-Host "Skipping ${depotId}: listed as exception (multi-volume/manual)"
        return
    }

    # check for 'downgrade' folder
    $downgradeDir = Join-Path $_.FullName 'downgrade'
    if (-not (Test-Path -Path $downgradeDir)) {
        Write-Host "Skipping ${depotId}: no 'downgrade' folder"
        return
    }

    # check if downgrade folder is not empty
    $files = Get-ChildItem -Path $downgradeDir -Recurse -File -ErrorAction SilentlyContinue
    if (-not $files -or $files.Count -eq 0) {
        Write-Host "Skipping ${depotId}: 'downgrade' is empty"
        return
    }

    $outFile = Join-Path '.\output' ("$depotId.7z")
    $sourcePattern = "$downgradeDir\*"

    # create archive
    Write-Host "Creating archive for $depotId -> $outFile"
    & 7za a -t7z $outFile $sourcePattern -m0=lzma2 -mx=5
}

# create multi volumes archives (exceptions)
& 7za a -t7z output/377163.7z .\depots\377163\downgrade\* -m0=lzma2 -mx=5 -v463m
& 7za a -t7z output/393883.7z .\depots\393883\downgrade\* -m0=lzma2 -mx=5 -v483m
& 7za a -t7z output/393884.7z .\depots\393884\downgrade\* -m0=lzma2 -mx=5 -v484m
