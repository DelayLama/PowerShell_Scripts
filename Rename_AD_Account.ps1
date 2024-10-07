# Define the user's current and new details
$currentUsername = "currentUsername"
$newFirstName = "NewFirstName"
$newLastName = "NewLastName"
$newDisplayName = "$newFirstName $newLastName"
$newUserPrincipalName = "$newFirstName.$newLastName@domain.com"
$newSamAccountName = "$newFirstName.$newLastName"

# Get the user object
$user = Get-ADUser -Identity $currentUsername -Properties mail, proxyAddresses

# Update the user's details
Set-ADUser -Identity $user -GivenName $newFirstName -Surname $newLastName -DisplayName $newDisplayName -UserPrincipalName $newUserPrincipalName -SamAccountName $newSamAccountName

# Add the old email address as an alias
$oldEmailAddress = $user.mail
$newPrimaryEmailAddress = $newUserPrincipalName
$proxyAddresses = $user.proxyAddresses
$proxyAddresses += "smtp:$oldEmailAddress"
$proxyAddresses += "SMTP:$newPrimaryEmailAddress"

# Update the user's email addresses
Set-ADUser -Identity $user -EmailAddress $newPrimaryEmailAddress -Replace @{proxyAddresses=$proxyAddresses}

Write-Output "User details updated successfully. The old email address has been kept as an alias."
