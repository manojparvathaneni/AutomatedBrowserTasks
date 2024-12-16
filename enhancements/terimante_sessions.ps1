# Import JSON configuration
$config = Get-Content -Raw -Path "config.json" | ConvertFrom-Json
$browser = $config.browser
$sessionsFile = "sessions.txt"
$logFile = "terminate_log.txt"

# Map browser names to process names (adjust as needed for different browsers)
$processNames = @{
    "chrome" = "chrome"
    "firefox" = "firefox"
    "edge" = "msedge"
}

if (-not $processNames.ContainsKey($browser)) {
    Add-Content -Path $logFile -Value "[$(Get-Date)] Browser $browser not supported for termination."
    exit
}

$expectedProcessName = $processNames[$browser]

# Log start
Add-Content -Path $logFile -Value "[$(Get-Date)] Starting browser session termination."

# Check if the sessions file exists
if (!(Test-Path $sessionsFile)) {
    Add-Content -Path $logFile -Value "[$(Get-Date)] No session file found. Exiting."
    exit
}

# Read PIDs from file and terminate matching processes
$PIDs = Get-Content -Path $sessionsFile
foreach ($PID in $PIDs) {
    try {
        # Get process information
        $process = Get-Process -Id $PID -ErrorAction Stop

        # Check if the process name matches the expected browser name
        if ($process.ProcessName -eq $expectedProcessName) {
            Stop-Process -Id $PID -Force -ErrorAction Stop
            Add-Content -Path $logFile -Value "[$(Get-Date)] Terminated process with PID $PID and name $($process.ProcessName)."
        } else {
            Add-Content -Path $logFile -Value "[$(Get-Date)] PID $PID does not match expected browser name ($expectedProcessName). Skipping."
        }
    } catch {
        Add-Content -Path $logFile -Value "[$(Get-Date)] Failed to handle PID $PID: $_"
    }
}

# Cleanup
Remove-Item $sessionsFile
Add-Content -Path $logFile -Value "[$(Get-Date)] All matching sessions terminated and session file removed."
