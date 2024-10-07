Set-TransportService WSL-WI-EX01 -ReceiveProtocolLogPath "L:\Logfiles\Hub SMTP Receive Log" -ReceiveProtocolLogMaxFileSize 20MB -ReceiveProtocolLogMaxDirectorySize 4000MB -ReceiveProtocolLogMaxAge 45.00:00:00 -SendProtocolLogPath "L:\Logfiles\Hub SMTP Send Log" -SendProtocolLogMaxFileSize 20MB -SendProtocolLogMaxDirectorySize 4000MB -SendProtocolLogMaxAge 45.00:00:00

Set-FrontEndTransportService WSL-WI-EX01 -ReceiveProtocolLogPath "L:\Logfiles\FrontEnd SMTP Receive Log" -ReceiveProtocolLogMaxFileSize 20MB -ReceiveProtocolLogMaxDirectorySize 4000MB -ReceiveProtocolLogMaxAge 45.00:00:00 -SendProtocolLogPath "L:\Logfiles\FrontEnd SMTP Send Log" -SendProtocolLogMaxFileSize 20MB -SendProtocolLogMaxDirectorySize 4000MB -SendProtocolLogMaxAge 45.00:00:00

Set-MailboxTransportService WSL-WI-EX01 -ReceiveProtocolLogPath "L:\Logfiles\Mailbox SMTP Receive Log" -ReceiveProtocolLogMaxFileSize 20MB -ReceiveProtocolLogMaxDirectorySize 4000MB -ReceiveProtocolLogMaxAge 45.00:00:00 -SendProtocolLogPath "L:\Logfiles\Mailbox SMTP Send Log" -SendProtocolLogMaxFileSize 20MB -SendProtocolLogMaxDirectorySize 4000MB -SendProtocolLogMaxAge 45.00:00:00




Move-DatabasePath -Identity WSL-EDB-01 -EdbFilePath H:\WSL-EDB-01\WSL-EDB-01.edb -LogFolderPath L:\EDB_TransactionLogs\WSL-EDB-01 -DomainController "WSL-WI-DC02"
Move-DatabasePath -Identity WSL-EDB-02 -EdbFilePath H:\WSL-EDB-02\WSL-EDB-02.edb -LogFolderPath L:\EDB_TransactionLogs\WSL-EDB-02 -DomainController "WSL-WI-DC02"


Set-ServerComponentState -Identity "WSL-WI-EX01" -Component HubTransport -State Draining -Requester Maintenance

Set-ServerComponentState "WSL-WI-EX01" -Component ServerWideOffline -State Inactive -Requester Maintenance



Set-ServerComponentState "WSL-WI-EX01" -Component ServerWideOffline -State Active -Requester Maintenance
Set-ServerComponentState "WSL-WI-EX01" -Component HubTransport -State Active -Requester Maintenance



Get-MessageTrackingLog -ResultSize Unlimited -Start "5/23/2024 20:00" -End "5/23/2034 22:00"
