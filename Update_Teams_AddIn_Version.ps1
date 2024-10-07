# Uninstall current Teams Add-in Version
$productCode = (Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*Teams Meeting Add-in*" }).IdentifyingNumber
Start-Process msiexec.exe -ArgumentList "/x $productCode /quiet /norestart" -NoNewWindow -Wait

# Find currently installed Teams appx package location and path to contained add-in installer
$basepath = "C:\Program Files\WindowsApps\"
$packagefullname = (Get-AppxPackage -Name "*Teams*").PackageFullName
$teamsinstallpath = Join-Path $basepath $packagefullname
$msiname = "MicrosoftTeamsMeetingAddinInstaller.msi"
$fullpathtomsi = Join-Path $teamsinstallpath $msiname
$addinbasepath = "C:\Program Files (x86)\Microsoft\TeamsMeetingAdd-in\"

# Get the AppLocker file information for the new Add-in MSI package
$binaryVersion = (Get-AppLockerFileInformation -Path $fullpathtomsi).Publisher.BinaryVersion.ToString()
$addininstallpath = Join-Path $addinbasepath $binaryVersion

# Create the directory for the new add-in version
New-Item -ItemType Directory -Path $addininstallpath -Force

# Install the new Teams Add-in version
Start-Process msiexec.exe -ArgumentList "/i `"$fullpathtomsi`" /qn /norestart ALLUSERS=1 TARGETDIR=`"$addininstallpath`"" -NoNewWindow -Wait
