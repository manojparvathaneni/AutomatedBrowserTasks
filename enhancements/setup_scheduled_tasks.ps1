# Import JSON configuration
$config = Get-Content -Raw -Path "config.json" | ConvertFrom-Json
$launchSchedule = $config.launchSchedule
$terminateSchedule = $config.terminateSchedule
$launchScriptPath = "C:\Path\To\launch_sessions.ps1"
$terminateScriptPath = "C:\Path\To\terminate_sessions.ps1"

# Secure credentials
$credentialFile = "credentials.xml"
if (!(Test-Path $credentialFile)) {
    Write-Host "Credentials file not found. Please create it using the following command:"
    Write-Host 'Export-Clixml -Path "credentials.xml" -InputObject (New-Object PSCredential "username", (Read-Host -AsSecureString "Enter Password"))'
    exit
}
$credentials = Import-Clixml -Path $credentialFile

# Set up the Launch Task
Write-Host "Setting up Launch Task"
$launchTrigger = New-ScheduledTaskTrigger -Daily -At $launchSchedule
$launchAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$launchScriptPath`""
Register-ScheduledTask -TaskName "LaunchBrowserSessions" -Trigger $launchTrigger -Action $launchAction -Credential $credentials

# Set up the Termination Task
Write-Host "Setting up Termination Task"
$terminateTrigger = New-ScheduledTaskTrigger -Daily -At $terminateSchedule
$terminateAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$terminateScriptPath`""
Register-ScheduledTask -TaskName "TerminateBrowserSessions" -Trigger $terminateTrigger -Action $terminateAction -Credential $credentials

Write-Host "Scheduled tasks created successfully."
