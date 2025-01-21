$filter = "(&(sAMAccountName={0})(memberOf=CN=WSL_Z1_Admins,OU=Sicherheitsgruppen,OU=Gruppen,OU=Benutzer_Gruppen_Computer,DC=wsl-patent,DC=local))"


w0wod3-b15epo-ser0za-zog4k3-wara



Import-ExchangeCertificate -FileData ([System.IO.File]::ReadAllBytes('C:\Users\administrator.AGVHC\Documents\Zertifikate\exchange.hessenchemie.de_cer\exchange.hessenchemie.de.PFX')) -FriendlyName "GlobalSign 25-26 exchange.hessenchemie.de" -Password (ConvertTo-SecureString -String 'b8zMPvyBE2h36PBfQ6Tq' -AsPlainText -Force) -PrivateKeyExportable:$true | Enable-ExchangeCertificate -Services "SMTP" -force


$Cert = Get-ExchangeCertificate -Thumbprint 63DF07BDE37AFE89C4CE02DF6F2312E1AFD009E7
$TLSCertificateName = "<i>$($Cert.Issuer)<s>$($Cert.Subject)"

Get-SendConnector | Set-SendConnector -TlsCertificateName $TLSCertificateName
Write-Host "WARNUNG: Der Befehl wurde erfolgreich abgeschlossen, es wurden jedoch keine Einstellungen von 'Outbound to Office 365 - ba686822-d6d5-4965-823f-32d564d12fba' geändert."
Set-ReceiveConnector -Identity "WIHCEX01\Default Frontend WIHCEX01" -TlsCertificateName $TLSCertificateName
Write-Host "WARNUNG: Der Befehl wurde erfolgreich abgeschlossen, es wurden jedoch keine Einstellungen von 'WIHCEX01\Default Frontend WIHCEX01' geändert."
Set-ReceiveConnector -Identity "WIHCEX01\Client Frontend WIHCEX01" -TlsCertificateName $TLSCertificateName
Write-Host "WARNUNG: Der Befehl wurde erfolgreich abgeschlossen, es wurden jedoch keine Einstellungen von 'WIHCEX01\Client Frontend WIHCEX01' geändert."