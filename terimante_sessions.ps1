# File containing the PIDs
$sessionsFile = "sessions.txt"

# Import JSON configuration
$config = Get-Content -Raw -Path "config.json" | ConvertFrom-Json
$browserName = $config.browser

# Map browser names to process names (adjust as needed for different browsers)
$processNames = @{
    "chrome" = "chrome"
    "firefox" = "firefox"
    "edge" = "msedge"
}

if (-not $processNames.ContainsKey($browserName)) {
    Write-Host "Browser $browserName not supported for termination."
    exit
}

$expectedProcessName = $processNames[$browserName]

# Check if the sessions file exists
if (!(Test-Path $sessionsFile)) {
    Write-Host "No session file found. Exiting."
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
            Write-Host "Terminated process with PID $PID and name $($process.ProcessName)."
        } else {
            Write-Host "PID $PID does not match expected browser name ($expectedProcessName). Skipping."
        }
    } catch {
        Write-Host "Failed to handle PID $PID. It may not exist or another error occurred."
    }
}

# Cleanup
Remove-Item $sessionsFile
Write-Host "All matching sessions terminated and session file removed."
