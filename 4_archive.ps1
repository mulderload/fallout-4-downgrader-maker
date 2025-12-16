if (-not (Test-Path -Path '.\output2024')) { New-Item -Path '.\output2024' -ItemType Directory | Out-Null }
if (-not (Test-Path -Path '.\output2019')) { New-Item -Path '.\output2019' -ItemType Directory | Out-Null }

function Compress-Downgrades {
    param(
        [string]$Year,
        [string[]]$Exceptions,
        [string]$OutputDirName
    )

    Get-ChildItem -Path '.\depots' -Directory | ForEach-Object {
        $depotId = $_.Name

        # skip exceptions
        if ($Exceptions -contains $depotId) {
            Write-Host "Skipping ${depotId}: listed as exception (multi-volume/manual)"
            return
        }

        # check for 'downgrade_XXXX' folder
        $downgradeDir = Join-Path $_.FullName ("downgrade_$Year")
        if (-not (Test-Path -Path $downgradeDir)) {
            Write-Host "Skipping ${depotId}: no 'downgrade_$Year' folder"
            return
        }

        # check if 'downgrade_XXXX' folder is not empty
        $files = Get-ChildItem -Path $downgradeDir -Recurse -File -ErrorAction SilentlyContinue
        if (-not $files -or $files.Count -eq 0) {
            Write-Host "Skipping ${depotId}: 'downgrade_$Year' is empty"
            return
        }

        $outFile = Join-Path ".\output${Year}" ("$depotId.7z")
        $sourcePattern = "$downgradeDir\*"

        Write-Host "Creating $Year archive for $depotId -> $outFile"
        & 7za a -t7z $outFile $sourcePattern -m0=lzma2 -mx=5
    }
}

Compress-Downgrades -Year '2024' -Exceptions @('377163')
& 7za a -t7z output2024\377163.7z .\depots\377163\downgrade_2024\* -m0=lzma2 -mx=5 -v463m

Compress-Downgrades -Year '2019' -Exceptions @('377163','393883','393884')
& 7za a -t7z output2019\377163.7z .\depots\377163\downgrade_2019\* -m0=lzma2 -mx=5 -v463m
& 7za a -t7z output2019\393883.7z .\depots\393883\downgrade_2019\* -m0=lzma2 -mx=5 -v483m
& 7za a -t7z output2019\393884.7z .\depots\393884\downgrade_2019\* -m0=lzma2 -mx=5 -v484m
