<#
.SYNOPSIS
  Create local admin acc

.DESCRIPTION
  Creates a local administrator account on de computer. Requires RunAs permissions to run

.OUTPUTS
  none

.NOTES
  Version:        1.0
  Author:         R. Mens - LazyAdmin.nl
  Creation Date:  25 march 2022
  Purpose/Change: Initial script development
#>

# Configuration
$username = "localadmin"   # Administrator is built-in name
$password = ConvertTo-SecureString "Poets6-Dumped6-My-Dip" -AsPlainText -Force  # Super strong plane text password here (yes this isn't secure at all)
$logFile = "\\DATEN\LocalAdminScript\create_localadmin_log.txt"
#import-module -SkipEditionCheck microsoft.powershell.localaccounts #Username and Password

Function Write-Log {
    param(
        [Parameter(Mandatory = $true)][string] $message,
        [Parameter(Mandatory = $false)]
        [ValidateSet("INFO", "WARN", "ERROR")]
        [string] $level = "INFO"
    )
    # Create timestamp
    $timestamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")

    # Append content to log file
    Add-Content -Path $logFile -Value "$timestamp [$level] - $message"
}

Function Create-LocalAdmin {
    process {
        try {
            
            Remove-LocalUser localadmin -ErrorAction Ignore
            Write-Log -message "Existing local user $username was deleted"
            
            New-LocalUser "$username" -Password $password -FullName "$username" -Description "local admin" -ErrorAction stop
            Write-Log -message "$username local user crated"

            # Add new user to administrator group
            Add-LocalGroupMember -Group "Administratoren" -Member "$username" -ErrorAction stop
            Write-Log -message "$username added to the local administrator group"
        }
        catch {
            Write-log -message "Creating local account failed" -level "ERROR"
        }
    }    
}

Write-Log -message "#########"
Write-Log -message "$env:COMPUTERNAME - Create local admin account"

Create-LocalAdmin

Write-Log -message "#########"