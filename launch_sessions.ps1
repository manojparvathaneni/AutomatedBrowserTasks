# Import JSON configuration
$config = Get-Content -Raw -Path "config.json" | ConvertFrom-Json

# Extract configuration details
$url = $config.url
$numWindows = $config.numWindows
$browser = $config.browser
$sessionsFile = "sessions.txt"

# Clear previous session data
if (Test-Path $sessionsFile) {
    Remove-Item $sessionsFile
}

# Open browser windows and track PIDs
for ($i = 1; $i -le $numWindows; $i++) {
    $process = Start-Process -FilePath $browser -ArgumentList "--new-window $url" -PassThru
    $process.Id | Out-File -Append -FilePath $sessionsFile
}
Write-Host "Launched $numWindows $browser windows with URL $url. PIDs saved to $sessionsFile."
