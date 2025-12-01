# auto-watch.ps1
# Version: 1.0
# Automatischer Pull + Push bei jeder Dateiänderung

$path = Get-Location

Write-Host "Watching for file changes in $path..."

# FileSystemWatcher starten
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $path
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true
$watcher.Filter = "*.*"

# Funktion: Sync
function Do-Sync {
    Write-Host "`n===== AUTO PULL ====="
    git pull

    Write-Host "`n===== AUTO PUSH ====="
    git add .
    git commit -m "Auto Sync" --allow-empty
    git push
}

# Event: Bei Änderung
Register-ObjectEvent $watcher Changed -Action { Do-Sync }
Register-ObjectEvent $watcher Created -Action { Do-Sync }
Register-ObjectEvent $watcher Deleted -Action { Do-Sync }
Register-ObjectEvent $watcher Renamed -Action { Do-Sync }

# Warte dauerhaft
while ($true) { Start-Sleep -Seconds 1 }
