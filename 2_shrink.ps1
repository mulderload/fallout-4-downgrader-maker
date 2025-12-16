# Remove some useless files / duplicate files

# 377161 - remove steam's installscript.vdf
Remove-Item -Path ".\depots\377161\latest\installscript.vdf"
Remove-Item -Path ".\depots\377161\2024\installscript.vdf"
Remove-Item -Path ".\depots\377161\2019\installscript.vdf"

# 377161 - remove duplicated / corrupted Meshes file (the good one is in 377163)
Remove-Item -Path ".\depots\377161\latest\Data\Fallout4 - Meshes.ba2"
Remove-Item -Path ".\depots\377161\2024\Data\Fallout4 - Meshes.ba2"
Remove-Item -Path ".\depots\377161\2019\Data\Fallout4 - Meshes.ba2"

# 393883 & 393884 - remove duplicated files (same files are in downgraded 377163)
foreach ($depot in '393883','393884') {
    foreach ($file in @(
        "2019\Data\Fallout4 - Animations.ba2",
        "2019\Data\Fallout4 - Geometry.csg",
        "2019\Data\Fallout4 - MeshesExtra.ba2",
        "2019\Data\Fallout4 - Nvflex.ba2",
        "2019\Data\Fallout4 - Shaders.ba2",
        "2019\Data\Fallout4 - Textures1.ba2",
        "2019\Data\Fallout4 - Textures2.ba2",
        "2019\Data\Fallout4 - Textures3.ba2",
        "2019\Data\Fallout4 - Textures4.ba2",
        "2019\Data\Fallout4 - Textures5.ba2",
        "2019\Data\Fallout4 - Textures6.ba2",
        "2019\Data\Fallout4 - Textures7.ba2",
        "2019\Data\Fallout4 - Textures8.ba2",
        "2019\Data\Fallout4 - Textures9.ba2",
        "2019\Data\Fallout4.cdx",
        "2019\Fallout4\Fallout4Prefs.ini",
        "2019\bink2w64.dll",
        "2019\cudart64_75.dll",
        "2019\Fallout4Launcher.exe",
        "2019\flexExtRelease_x64.dll",
        "2019\flexRelease_x64.dll",
        "2019\GFSDK_GodraysLib.x64.dll",
        "2019\GFSDK_SSAO_D3D11.win64.dll",
        "2019\High.ini",
        "2019\Low.ini",
        "2019\Medium.ini",
        "2019\msvcp110.dll",
        "2019\msvcr110.dll",
        "2019\nvdebris.txt",
        "2019\nvToolsExt64_1.dll",
        "2019\steam_api64.dll",
        "2019\Ultra.ini"
    )) {
        Remove-Item -Path ".\depots\$depot\$file"
    }
}
