# Directory where logs are stored
$logDirectory = "C:\Path\To\Your\Logs"
# Log file name pattern
$logFilePattern = "LogFile_{0:yyyy-MM-dd}.txt"

# Function to log messages
function Log-Message {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logFile = [System.IO.Path]::Combine($logDirectory, [string]::Format($logFilePattern, (Get-Date)))
    Add-Content -Path $logFile -Value "$timestamp - $message"
}

# Function to rotate logs
function Rotate-Logs {
    $files = Get-ChildItem -Path $logDirectory -Filter "LogFile_*.txt" | Sort-Object LastWriteTime -Descending
    if ($files.Count -gt 30) {
        $filesToDelete = $files | Select-Object -Skip 30
        foreach ($file in $filesToDelete) {
            Remove-Item -Path $file.FullName -Force
        }
    }
}

# Rotate logs at the start of the script
Rotate-Logs

# Function to monitor and restart the service
function Monitor-Service {
    while ($true) {
        $service = Get-Service -Name "Genese_Service"
        if ($service.Status -ne 'Running') {
            Log-Message "Service 'Genese_Service' is not running. Attempting to start."
            Start-Service -Name "Genese_Service"
            if ((Get-Service -Name "Genese_Service").Status -eq 'Running') {
                Log-Message "Service 'Genese_Service' started successfully."
            } else {
                Log-Message "Failed to start service 'Genese_Service'."
            }
        } else {
            Log-Message "Service 'Genese_Service' is running."
        }
        Start-Sleep -Seconds 60  # Check every 60 seconds
    }
}

# Start monitoring the service in a background job
$job = Start-Job -ScriptBlock { Monitor-Service }

# Function to handle the scheduled restart
function Scheduled-Restart {
    while ($true) {
        $scheduledTime = [datetime]::Today.AddHours(24.5)  # 00:30 next day
        $currentTime = Get-Date
        $timeToWait = $scheduledTime - $currentTime

        if ($timeToWait.TotalSeconds -lt 0) {
            $scheduledTime = $scheduledTime.AddDays(1)
            $timeToWait = $scheduledTime - $currentTime
        }

        Log-Message "Waiting until $scheduledTime to restart the service."
        Start-Sleep -Seconds $timeToWait.TotalSeconds

        Restart-Service -Name "Genese_Service"
        Log-Message "Service 'Genese_Service' restarted at $scheduledTime."
    }
}

# Start the scheduled restart in a background job
$restartJob = Start-Job -ScriptBlock { Scheduled-Restart }
