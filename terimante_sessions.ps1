# Import JSON configuration
$config = Get-Content -Raw -Path "config.json" | ConvertFrom-Json
$browser = $config.browser
$logFile = "terminate_log.txt"

# Map browser names to process names
$processNames = @{
    "chrome" = "chrome"
    "msedge"   = "msedge"
    "firefox"= "firefox"
}

if (-not $processNames.ContainsKey($browser)) {
    Add-Content -Path $logFile -Value "[$(Get-Date)] Browser $browser is not supported."
    exit
}

$expectedProcessName = $processNames[$browser]

# Log start
Add-Content -Path $logFile -Value "[$(Get-Date)] Starting termination for browser: $browser."

try {
    # Find all processes matching the browser name
    $browserProcesses = Get-Process | Where-Object { $_.ProcessName -eq $expectedProcessName }

    if ($browserProcesses) {
        foreach ($browserProcess in $browserProcesses) {
            try {
                # Terminate the process
                Stop-Process -Id $browserProcess.Id -Force -ErrorAction Stop
                Add-Content -Path $logFile -Value "[$(Get-Date)] Terminated process: $($browserProcess.ProcessName) with PID: $($browserProcess.Id)."
            } catch {
                Add-Content -Path $logFile -Value "[$(Get-Date)] Failed to terminate PID: $($browserProcess.Id). Error: $_"
            }
        }
    } else {
        Add-Content -Path $logFile -Value "[$(Get-Date)] No processes found for browser: $browser."
    }
} catch {
    Add-Content -Path $logFile -Value "[$(Get-Date)] An error occurred: $_"
}

Add-Content -Path $logFile -Value "[$(Get-Date)] Termination process completed."
