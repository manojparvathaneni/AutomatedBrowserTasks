# Import JSON configuration
$config = Get-Content -Raw -Path "config.json" | ConvertFrom-Json

# Extract configuration details
$url = $config.url
$numWindows = $config.numWindows
$browser = $config.browser
$sessionsFile = "sessions.txt"
$logFile = "launch_log.txt"

# Clear previous session data
if (Test-Path $sessionsFile) {
    Remove-Item $sessionsFile
}

# Log start
Add-Content -Path $logFile -Value "[$(Get-Date)] Starting browser session launch."

# Open browser windows and track PIDs
for ($i = 1; $i -le $numWindows; $i++) {
    try {
        $process = Start-Process -FilePath $browser -ArgumentList "--new-window $url" -PassThru
        $process.Id | Out-File -Append -FilePath $sessionsFile
        Add-Content -Path $logFile -Value "[$(Get-Date)] Launched $browser window with PID $($process.Id)."
    } catch {
        Add-Content -Path $logFile -Value "[$(Get-Date)] Error launching browser window: $_"
    }
}
Add-Content -Path $logFile -Value "[$(Get-Date)] Completed browser session launch."
