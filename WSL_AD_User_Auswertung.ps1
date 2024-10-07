$users = Get-ADUser -Filter "ObjectClass -eq 'user'"  -Properties DistinguishedName, Name, UserPrincipalName, WhenChanged, WhenCreated, sAMAccountName, pwdlastset, objectSID, lastLogon, BadPasswordTime, Description, Mail, proxyAddresses, ObjectClass

$usersWithFormattedTimestamp = foreach ($user in $users) {

    $formattedLogonTimestamp = if ($user.LastLogonTimestamp) {

        [DateTime]::FromFileTime($user.LastLogonTimestamp).ToString("yyyy-MM-dd HH:mm:ss")

    } 

    $formattedPwdLastSetTimestamp = if ($user.pwdlastset) {

        [DateTime]::FromFileTime($user.pwdlastset).ToString("yyyy-MM-dd HH:mm:ss")

    } 

    $formattedBadPasswordTimestamp = if ($user.BadPasswordTime) {

        [DateTime]::FromFileTime($user.BadPasswordTime).ToString("yyyy-MM-dd HH:mm:ss")

    } 

    

    [PSCustomObject]@{

        Name               = $user.Name
        WhenCreated        = $user.WhenCreated
        WhenChanged        = $user.WhenChanged
        DistinguishedName  = $user.DistinguishedName
        UserPrincipalName  = $user.UserPrincipalName
        LastLogonTimestamp = $formattedLogonTimestamp
        pwdlastset         = $formattedPwdLastSetTimestamp
        BadPasswordTime    = $formattedBadPasswordTimestamp
        sAMAccountName     = $user.sAMAccountName
        objectSID          = $user.objectSID
        Description        = $user.Description
        Mail               = $user.Mail
        proxyAddresses     = $user.proxyAddresses
        ObjectClass        = $user.ObjectClass
    }

}

$usersWithFormattedTimestamp | Export-Csv -Path "C:\temp\ADUserExport_$((Get-Date).ToString("yyyyMMdd_HHmmss")).csv" -NoTypeInformation
