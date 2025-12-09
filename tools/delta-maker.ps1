# Todo : 
# - factorize with mulderload/diff-maker
# - add checkbox on UI to enable / disable xdelta option
# - add habitility to skip xdelta for ini files & maybe other text files

param (
    [string]$sourcePath,
    [string]$targetPath,
    [string]$outputPath,
    [string]$txtOutputPath
)

if (-not $sourcePath -or -not $targetPath -or -not $outputPath) {
    Write-Host "All parameters (sourcePath, targetPath, outputPath) must be provided."
    exit
}

if (-not (Test-Path $sourcePath) -or -not (Test-Path $targetPath)) {
    Write-Host "One or more paths are invalid."
    exit
}

if (-not (Test-Path $outputPath)) {
    New-Item -Path $outputPath -ItemType Directory -Force | Out-Null
}

# Scans
$sourceFiles = @{}  # Relative files paths in source (key: filePath / value: hash)
$sourceHashes = @{} # Reverse of sourceFiles         (key: hash     / value: filePath)
$targetFiles = @{}  # Relative file paths in target  (key: filePath / value: hash)

# Results
$newFiles = @()
$copiedFiles = @{}
$deletedFiles = @()
$modifiedFiles = @()

function Get-RelativePath($fullPath, $basePath) {
    return $fullPath.Substring($basePath.Length).TrimStart('\')
}

# Scan files in sourcePath
Get-ChildItem -Path $sourcePath -Recurse -File | ForEach-Object {
    $relPath = Get-RelativePath $_.FullName $sourcePath
    $hash = (Get-FileHash $_.FullName -Algorithm SHA256).Hash

    $sourceFiles[$relPath] = $hash
    $sourceHashes[$hash] = $relPath
}

# Scan files in targetPath
Get-ChildItem -Path $targetPath -Recurse -File | ForEach-Object {
    $relPath = Get-RelativePath $_.FullName $targetPath
    $hash = (Get-FileHash $_.FullName -Algorithm SHA256).Hash

    $targetFiles[$relPath] = $hash
}

# Compare files from targetPath
foreach ($targetFile in $targetFiles.GetEnumerator()) {
    $targetRelPath = $targetFile.Key
    $targetHash = $targetFile.Value

    if ($sourceFiles.ContainsKey($targetRelPath)) {
        $sourceHash = $sourceFiles[$targetRelPath];
        if ($sourceHash -ne $targetHash) {
            if ($targetRelPath.EndsWith(".ini")) {
                Write-Output "[MODIFY] `t $targetRelPath"
                $newFiles += $targetRelPath;
            } else {
                Write-Output "[MODIFY] `t $targetRelPath"
                $modifiedFiles += $targetRelPath;
            }
        }
    } elseif ($sourceHashes.ContainsKey($targetHash)) {
        $sourceRelPath = $sourceHashes[$targetHash];
        Write-Output "[COPY] `t`t $sourceRelPath => $targetRelPath"
        $copiedFiles[$targetRelPath] = $sourceRelPath;
    } else {
        Write-Output "[NEW] `t`t $targetRelPath"
        $newFiles += $targetRelPath;
    }
}

# Compare files from sourcePath (to find deleted files)
foreach($sourceRelPath in $sourceFiles.Keys) {
    if (-not $targetFiles.ContainsKey($sourceRelPath)) {
        Write-Output "[DELETE] `t $sourceRelPath"
        $deletedFiles += $sourceRelPath;
    }
}

# Copy newFiles to outputPath
foreach ($file in $newFiles) {
    $targetFilePath = Join-Path $targetPath $file
    $destinationFilePath = Join-Path $outputPath $file

    # Créer les sous-dossiers nécessaires dans le dossier de destination
    $destinationDir = Split-Path $destinationFilePath -Parent
    if (-not (Test-Path $destinationDir)) {
        # Créer les répertoires parents nécessaires
        New-Item -Path $destinationDir -ItemType Directory -Force | Out-Null
    }

    # Copier le fichier
    Write-Output "[ADD] $destinationFilePath"
    Copy-Item -Path $targetFilePath -Destination $destinationFilePath -Force
}

# Generate xdeltas for modified files
foreach ($file in $modifiedFiles) {
    $sourceFilePath = Join-Path $sourcePath $file
    $targetFilePath = Join-Path $targetPath $file
    $deltaFilePath = Join-Path $outputPath ($file + ".xdelta")

    # Créer les sous-dossiers nécessaires dans le dossier de destination
    $deltaDir = Split-Path $deltaFilePath -Parent
    if (-not (Test-Path $deltaDir)) {
        # Créer les répertoires parents nécessaires
        New-Item -Path $deltaDir -ItemType Directory -Force | Out-Null
    }

    $quotedSource = '"' + $sourceFilePath + '"'
    $quotedTarget = '"' + $targetFilePath + '"'
    $quotedDelta  = '"' + $deltaFilePath + '"'

    Start-Process ".\xdelta3.exe" -ArgumentList "-e -0 -S none -s $quotedSource $quotedTarget $quotedDelta" -NoNewWindow -Wait
}

# Generate nsis.txt
if (Test-Path $txtOutputPath) {
    # Clear file if already exists
    Clear-Content $txtOutputPath
} else {
    # Or create empty file
    New-Item -Path $txtOutputPath -ItemType File | Out-Null
}

# Write "CopyFiles" instructions
foreach ($targetRelPath in $copiedFiles.Keys | Sort-Object) {
    $sourceRelPath = $copiedFiles[$targetRelPath]
    
    # Ajouter une ligne CopyFiles dans le fichier NSIS
    Add-Content -Path $txtOutputPath -Value "CopyFiles ""$sourceRelPath"" ""$targetRelPath"""
}

# Write "Delete" instructions
foreach ($deletedFile in $deletedFiles | Sort-Object) {
    # Ajouter une ligne Delete dans le fichier NSIS
    Add-Content -Path $txtOutputPath -Value "Delete ""$deletedFile"""
}
