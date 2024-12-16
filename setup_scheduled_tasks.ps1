# Paths to scripts
$launchScriptPath = "C:\Path\To\launch_sessions.ps1"
$terminateScriptPath = "C:\Path\To\terminate_sessions.ps1"

# Task names
$launchTaskName = "LaunchBrowserSessions"
$terminateTaskName = "TerminateBrowserSessions"

# Prompt for user credentials
Write-Host "Please enter the credentials for running the tasks:"
$credential = Get-Credential

# Extract username and password
$username = $credential.UserName
$password = $credential.GetNetworkCredential().Password

# Set up the Launch Task
Write-Host "Setting up task: $launchTaskName"
$launchTrigger = New-ScheduledTaskTrigger -Daily -At "00:00"
$launchTrigger.RepetitionInterval = "PT1H" # Repeat every hour
$launchAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$launchScriptPath`""
$launchSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
Register-ScheduledTask -TaskName $launchTaskName -Trigger $launchTrigger -Action $launchAction -Settings $launchSettings -User $username -Password $password

# Set up the Termination Task
Write-Host "Setting up task: $terminateTaskName"
$terminateTrigger = New-ScheduledTaskTrigger -Daily -At "00:25"
$terminateTrigger.RepetitionInterval = "PT1H" # Repeat every hour, 25 minutes past
$terminateAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$terminateScriptPath`""
$terminateSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
Register-ScheduledTask -TaskName $terminateTaskName -Trigger $terminateTrigger -Action $terminateAction -Settings $terminateSettings -User $username -Password $password

Write-Host "Scheduled tasks created successfully."

