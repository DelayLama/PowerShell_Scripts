# Specify inactivity range value below
$DaysInactive = 90
# $time variable converts $DaysInactive to LastLogonTimeStamp property format for the -Filter switch to work

$time = (Get-Date).Adddays( - ($DaysInactive))

# Identify inactive computer accounts

$computers = Get-ADComputer -Filter { LastLogonTimeStamp -lt $time } -ResultPageSize 2000 -resultSetSize $null -Properties Name, OperatingSystem, SamAccountName, DistinguishedName, LastLogonTimestamp, DNSHostName, pwdlastset, badpasswordtime, ObjectClass, Objectguid, OperatingSystem, SID, UserPRincipalName, WhenCreated, WhenChanged



$computersWithFormattedTimestamp = foreach ($computer in $computers) {

    $formattedLogonTimestamp = if ($computer.LastLogonTimeStamp) {

        [DateTime]::FromFileTime($computer.LastLogonTimestamp).ToString("yyyy-MM-dd HH:mm:ss")

    } 

    $formattedPwdLastSetTimestamp = if ($computer.pwdlastset) {

        [DateTime]::FromFileTime($computer.pwdlastset).ToString("yyyy-MM-dd HH:mm:ss")

    } 

    $formattedBadPasswordTimestamp = if ($computer.BadPasswordTime) {

        [DateTime]::FromFileTime($computer.BadPasswordTime).ToString("yyyy-MM-dd HH:mm:ss")

    } 

    

    [PSCustomObject]@{

        Name               = $computer.Name
        WhenCreated        = $computer.WhenCreated
        WhenChanged        = $computer.WhenChanged
        DistinguishedName  = $computer.DistinguishedName
        UserPrincipalName  = $computer.UserPrincipalName
        LastLogonTimestamp = $formattedLogonTimestamp
        pwdlastset         = $formattedPwdLastSetTimestamp
        BadPasswordTime    = $formattedBadPasswordTimestamp
        sAMAccountName     = $computer.sAMAccountName
        objectSID          = $computer.objectSID
        Description        = $computer.Description
        Mail               = $computer.Mail
        proxyAddresses     = $computer.proxyAddresses
        ObjectClass        = $computer.ObjectClass
        OjectGUID          = $computer.Objectguid
        OperatingSystem    = $computer.OperatingSystem
        DNSHostName        = $computer.DNSHostName
        Enabled            = $computer.Enabled
        SID                = $computer.SID

    }

}

$computersWithFormattedTimestamp | Export-Csv -Path "C:\temp\ADComputerExport_$((Get-Date).ToString("yyyyMMdd_HHmmss")).csv" -NoTypeInformation
