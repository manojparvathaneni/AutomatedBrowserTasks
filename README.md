
# Browser Session Management Automation

This project provides scripts to manage browser sessions by launching browser windows at specified intervals and terminating them after a defined period. It uses PowerShell scripts and Windows Task Scheduler for automation.

---

## **Files in This Project**

### 1. **`config.json`**
   - A configuration file that specifies parameters for the scripts.
   - **Fields**:
     - `url`: The website URL to open.
     - `numWindows`: Number of browser windows to open.
     - `browser`: Browser to use (e.g., `chrome`, `firefox`).

### 2. **`launch_sessions.ps1`**
   - Launches multiple browser windows based on the settings in `config.json`.
   - Captures the Process IDs (PIDs) of launched browser instances and stores them in a `sessions.txt` file for later termination.

### 3. **`terminate_sessions.ps1`**
   - Reads the `sessions.txt` file and terminates the browser processes whose PIDs are listed, ensuring the process name matches the browser specified in `config.json`.

### 4. **`setup_scheduled_tasks.ps1`**
   - Creates two scheduled tasks in Windows Task Scheduler:
     - One to run `launch_sessions.ps1` at the start of every hour.
     - Another to run `terminate_sessions.ps1` at 25 minutes past the hour.
   - Prompts for credentials to assign a user account under which the tasks will run.

---

## **Setup and Usage**

### 1. **Install Prerequisites**
   - Ensure `PowerShell 5.0+` is installed.
   - Place the scripts in a directory of your choice (e.g., `C:\Scripts\BrowserAutomation`).

### 2. **Configure Parameters**
   - Edit `config.json` to specify:
     ```json
     {
       "url": "https://example.com",
       "numWindows": 5,
       "browser": "chrome"
     }
     ```
   - Supported browsers include `chrome`, `firefox`, and `msedge`. Ensure the browser executable is in the system PATH.

### 3. **Test Scripts Manually**
   - Run `launch_sessions.ps1` to verify it opens the desired browser windows and creates the `sessions.txt` file:
     ```powershell
     powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\BrowserAutomation\launch_sessions.ps1"
     ```
   - Run `terminate_sessions.ps1` to terminate the launched browser processes:
     ```powershell
     powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\BrowserAutomation\terminate_sessions.ps1"
     ```

### 4. **Set Up Scheduled Tasks**
   - Run `setup_scheduled_tasks.ps1` as an administrator:
     ```powershell
     powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\BrowserAutomation\setup_scheduled_tasks.ps1"
     ```
   - This script will:
     - Prompt you for credentials.
     - Register tasks to:
       - Launch browser sessions at the top of every hour.
       - Terminate browser sessions 25 minutes past every hour.

### 5. **Verify Scheduled Tasks**
   - Open Task Scheduler (`taskschd.msc`) and check for:
     - `LaunchBrowserSessions`: Triggered every hour on the hour.
     - `TerminateBrowserSessions`: Triggered every hour at 25 minutes past the hour.

---

## **Security Considerations**

- **Credentials**:
  - `setup_scheduled_tasks.ps1` prompts for credentials to assign a user account for the tasks.
  - Use a dedicated service account with minimal permissions.
- **Sensitive Information**:
  - Avoid storing passwords in plaintext. If required, encrypt them using PowerShell's `SecureString` functionality.

---

## **Advanced Configuration**

### Custom Repetition Interval
   - Modify the task triggers in `setup_scheduled_tasks.ps1` to adjust the schedule. For example:
     ```powershell
     $launchTrigger.RepetitionInterval = "PT2H" # Repeat every 2 hours
     ```

### Supported Browsers
   - Update the `terminate_sessions.ps1` script if additional browsers need to be supported. Ensure the process name matches the browser executable.

---

## **Troubleshooting**

1. **Scripts Not Executing**:
   - Ensure `ExecutionPolicy` is set to allow scripts to run:
     ```powershell
     Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
     ```

2. **Tasks Not Running**:
   - Verify the user account assigned to the tasks has sufficient permissions.
   - Check task history in Task Scheduler for errors.

3. **Processes Not Terminated**:
   - Ensure the process name in `terminate_sessions.ps1` matches the executable name for the configured browser in `config.json`.

---

## **Future Improvements**

- Add logging to the scripts for better debugging and monitoring.
- Enhance `config.json` to include additional configuration options (e.g., custom schedules).
- Implement encrypted credential storage for enhanced security.

---

This setup automates browser session management efficiently.
