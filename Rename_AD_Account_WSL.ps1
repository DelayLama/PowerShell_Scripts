# Define the user's current and new details
$currentUsername = "currentUsername"
$newFirstName = "NewFirstName"
$newLastName = "NewLastName"
$newDisplayName = "$newLastName, $newFirstName "

# Construct the new UPN and email address
$newUserPrincipalName = "$($newFirstName.Substring(0,1))$($newLastName.Substring(0,2))@wsl-patent.local"
$newEmailAddress = "$($newFirstName.Substring(0,1)).$newLastName@wsl-patent.de"
$newSamAccountName = "$($newFirstName.Substring(0,1))$($newLastName.Substring(0,2))"
$mailNickname = "$($newFirstName.Substring(0,1)).$newLastName"

# Get the user object
$user = Get-ADUser -Identity $currentUsername -Properties mail, proxyAddresses, mailNickname

# Update the user's details
Set-ADUser -Identity $user -GivenName $newFirstName -Surname $newLastName -DisplayName $newDisplayName -UserPrincipalName $newUserPrincipalName -SamAccountName $newSamAccountName -Replace @{mailNickname=$mailNickname}

# Add the old email address as an alias
$oldEmailAddress = $user.mail
$proxyAddresses = $user.proxyAddresses
$proxyAddresses += "smtp:$oldEmailAddress"
$proxyAddresses += "SMTP:$newEmailAddress"

# Update the user's email addresses
Set-ADUser -Identity $user -EmailAddress $newEmailAddress -Replace @{proxyAddresses=$proxyAddresses}

Write-Output "User details updated successfully. The old email address has been kept as an alias."
