function CreateJunction($app, $depot, $dir) {
    New-Item -ItemType Directory -Path "${dir}" -Force | Out-Null

    if (Test-Path -path "C:\Program Files (x86)\Steam\steamapps\content\app_${app}\depot_${depot}") {
        Remove-Item "C:\Program Files (x86)\Steam\steamapps\content\app_${app}\depot_${depot}" -Recurse -Force
    }
    
    New-Item -Path "C:\Program Files (x86)\Steam\steamapps\content\app_${app}\depot_${depot}" -ItemType Junction -Target "${dir}" | Out-Null
}

function RemoveJunction($app, $depot) {
    if (Test-Path -path "C:\Program Files (x86)\Steam\steamapps\content\app_${app}\depot_${depot}") {
        Remove-Item "C:\Program Files (x86)\Steam\steamapps\content\app_${app}\depot_${depot}" -Recurse -Force
    }
}

function SteamDownload($app, $depot, $manifest, $dir) {
    CreateJunction -app $app -depot $depot -dir $dir

    Write-Host "`nDownloading depot ${depot} / manifest ${manifest}"
    Start-Process "C:\Program Files (x86)\Steam\steam.exe" -ArgumentList "+download_depot ${app} ${depot} ${manifest}"

    do {
        Start-Sleep -Seconds 2
        Write-Host -NoNewline "."
    } while (Test-Path -Path "C:\Program Files (x86)\Steam\steamapps\content\app_${app}\state_${app}_${depot}.patch")

    Write-Host "`nDownload of depot ${depot} completed."

    RemoveJunction -app $app -depot $depot
}
