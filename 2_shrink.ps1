# Remove some useless files / duplicate files

# 377161 - remove steam's installscript.vdf
Remove-Item -Path ".\depots\377161\new\installscript.vdf"
Remove-Item -Path ".\depots\377161\old\installscript.vdf"

# 377161 - remove duplicated / corrupted Meshes file (the good one is in 377163)
Remove-Item -Path ".\depots\377161\new\Data\Fallout4 - Meshes.ba2"
Remove-Item -Path ".\depots\377161\old\Data\Fallout4 - Meshes.ba2"

# 393883 & 393884 - remove duplicated files (same files are in downgraded 377163)
foreach ($depot in '393883','393884') {
    foreach ($file in @(
        "old\Data\Fallout4 - Animations.ba2",
        "old\Data\Fallout4 - Geometry.csg",
        "old\Data\Fallout4 - MeshesExtra.ba2",
        "old\Data\Fallout4 - Nvflex.ba2",
        "old\Data\Fallout4 - Shaders.ba2",
        "old\Data\Fallout4 - Textures1.ba2",
        "old\Data\Fallout4 - Textures2.ba2",
        "old\Data\Fallout4 - Textures3.ba2",
        "old\Data\Fallout4 - Textures4.ba2",
        "old\Data\Fallout4 - Textures5.ba2",
        "old\Data\Fallout4 - Textures6.ba2",
        "old\Data\Fallout4 - Textures7.ba2",
        "old\Data\Fallout4 - Textures8.ba2",
        "old\Data\Fallout4 - Textures9.ba2",
        "old\Data\Fallout4.cdx",
        "old\Fallout4\Fallout4Prefs.ini",
        "old\bink2w64.dll",
        "old\cudart64_75.dll",
        "old\Fallout4Launcher.exe",
        "old\flexExtRelease_x64.dll",
        "old\flexRelease_x64.dll",
        "old\GFSDK_GodraysLib.x64.dll",
        "old\GFSDK_SSAO_D3D11.win64.dll",
        "old\High.ini",
        "old\Low.ini",
        "old\Medium.ini",
        "old\msvcp110.dll",
        "old\msvcr110.dll",
        "old\nvdebris.txt",
        "old\nvToolsExt64_1.dll",
        "old\steam_api64.dll",
        "old\Ultra.ini"
    )) {
        Remove-Item -Path ".\depots\$depot\$file"
    }
}
