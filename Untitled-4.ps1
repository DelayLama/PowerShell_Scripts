Get-ADUser -Filter * -SearchBase "OU=Benutzer,OU=Benutzer_Gruppen_Computer,DC=wsl-patent,DC=local" -properties ScriptPath | ft Name, scriptpath | Set-ADUser -Clear scriptPath
