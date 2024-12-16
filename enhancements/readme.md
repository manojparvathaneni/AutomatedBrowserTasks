
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
     - `launchSchedule`: Custom schedule for launching browser sessions (e.g., `"hourly"`, `"daily at 9:00 AM"`).
     - `terminateSchedule`: Custom schedule for terminating browser sessions (e.g., `"25 minutes after launch"`).

### 2. **`launch_sessions.ps1`**
   - Launches multiple browser windows based on the settings in `config.json`.
   - Captures the Process IDs (PIDs) of launched browser instances and stores them in a `sessions.txt` file for later termination.
   - Logs each operation to `launch_log.txt` for debugging and monitoring.

### 3. **`terminate_sessions.ps1`**
   - Reads the `sessions.txt` file and terminates the browser processes whose PIDs are listed, ensuring the process name matches the browser specified in `config.json`.
   - Logs termination results to `terminate_log.txt` for debugging and monitoring.

### 4. **`setup_scheduled_tasks.ps1`**
   - Creates two scheduled tasks in Windows Task Scheduler:
     - One to run `launch_sessions.ps1` based on the `launchSchedule` in `config.json`.
     - Another to run `terminate_sessions.ps1` based on the `terminateSchedule` in `config.json`.
   - Prompts for credentials to assign a user account under which the tasks will run.
   - Stores credentials securely using PowerShell's `SecureString` functionality.

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
       "browser": "chrome",
       "launchSchedule": "hourly",
       "terminateSchedule": "25 minutes after launch"
     }
     ```
   - Supported browsers include `chrome`, `firefox`, and `msedge`. Ensure the browser executable is in the system PATH.

### 3. **Secure Credentials**
   - Run the following command to securely encrypt and save credentials for use by the scheduled tasks:
     ```powershell
     $username = "your-username"
     $password = Read-Host -AsSecureString "Enter Password"
     Export-Clixml -Path "C:\Scripts\BrowserAutomation\credentials.xml" -InputObject (New-Object PSCredential ($username, $password))
     ```

### 4. **Test Scripts Manually**
   - Run `launch_sessions.ps1` to verify it opens the desired browser windows, creates the `sessions.txt` file, and logs the operation:
     ```powershell
     powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\BrowserAutomation\launch_sessions.ps1"
     ```
   - Run `terminate_sessions.ps1` to terminate the launched browser processes and log the results:
     ```powershell
     powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\BrowserAutomation\terminate_sessions.ps1"
     ```

### 5. **Set Up Scheduled Tasks**
   - Run `setup_scheduled_tasks.ps1` as an administrator:
     ```powershell
     powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\BrowserAutomation\setup_scheduled_tasks.ps1"
     ```
   - This script will:
     - Register tasks based on the custom schedules in `config.json`.
     - Use securely stored credentials from `credentials.xml`.

### 6. **Verify Scheduled Tasks**
   - Open Task Scheduler (`taskschd.msc`) and check for:
     - `LaunchBrowserSessions`: Triggered based on `launchSchedule`.
     - `TerminateBrowserSessions`: Triggered based on `terminateSchedule`.

---

## **Security Considerations**

### **How `credentials.xml` Works**
- The `credentials.xml` file is encrypted using the **Data Protection API (DPAPI)**.
- The encryption is specific to the user account and machine where it was created.
- Only the same user account on the same machine can decrypt and use the `credentials.xml` file.

### **Potential Risks**
- If an attacker gains access to the `credentials.xml` file *and* your user profile, they can decrypt the credentials.
- Malware running under your user account could misuse the file.

### **Mitigation Strategies**
1. **Secure Your User Account**:
   - Use a strong password for your account.
   - Enable multi-factor authentication (MFA) if available.
   - Lock your system when not in use.

2. **Restrict Access to `credentials.xml`**:
   - Use the following command to restrict file access to your user account:
     ```powershell
     icacls "C:\Scripts\BrowserAutomation\credentials.xml" /inheritance:r /grant:r YourUserName:F
     ```

3. **Use a Dedicated Automation Account**:
   - Create a separate service account with minimal permissions for running these tasks.

4. **Monitor for Unauthorized Access**:
   - Regularly review and monitor access to the `credentials.xml` file.

5. **Consider Using a Secrets Manager**:
   - For highly sensitive tasks, use a dedicated secrets management solution like Azure Key Vault or HashiCorp Vault.

---

## **Advanced Configuration**

### Custom Schedules
   - Modify `launchSchedule` and `terminateSchedule` in `config.json` to customize task timing. For example:
     ```json
     "launchSchedule": "daily at 9:00 AM",
     "terminateSchedule": "30 minutes after launch"
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

- Add additional error handling and recovery mechanisms.
- Expand logging to include task execution metrics (e.g., timestamps, success/failure counts).
- Integrate with a monitoring tool for better visibility of script performance.

---

This setup automates browser session management efficiently. 
