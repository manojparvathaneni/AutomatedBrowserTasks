# Import JSON configuration
$config = Get-Content -Raw -Path "config.json" | ConvertFrom-Json

# Extract configuration details
$url = $config.url
$numWindows = $config.numWindows
$browser = $config.browser
$logFile = "launch_log.txt"

# Log start
Add-Content -Path $logFile -Value "[$(Get-Date)] Starting browser session launch for browser: $browser."

# Map browser executable names
$browserPaths = @{
    "chrome" = "chrome"
    "msedge"   = "msedge"
    "firefox"= "firefox"
}

if (-not $browserPaths.ContainsKey($browser)) {
    Add-Content -Path $logFile -Value "[$(Get-Date)] Browser $browser is not supported."
    exit
}

$browserExecutable = $browserPaths[$browser]

try {
    # Launch browser windows
    for ($i = 1; $i -le $numWindows; $i++) {
        try {
            Start-Process -FilePath $browserExecutable -ArgumentList "--new-window $url"
            Add-Content -Path $logFile -Value "[$(Get-Date)] Launched $browser window ($i of $numWindows)."
        } catch {
            Add-Content -Path $logFile -Value "[$(Get-Date)] Failed to launch $browser window ($i). Error: $_"
        }
    }
    Add-Content -Path $logFile -Value "[$(Get-Date)] Completed browser session launch."
} catch {
    Add-Content -Path $logFile -Value "[$(Get-Date)] An unexpected error occurred: $_"
}

