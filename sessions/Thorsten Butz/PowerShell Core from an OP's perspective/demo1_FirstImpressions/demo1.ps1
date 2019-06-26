#############################################
# Try this on different Windows 10 releases:
# Windows 10-1903, Windows 10-1807 etc ..
#############################################

# Count Cmdlets
(Get-Command -Name *-* -CommandType Cmdlet, Function).count     
winver.exe

# My favourite cmdlets

# Networking
Test-Connection -ComputerName sea-dc1 
Test-NetConnection -ComputerName sea-dc1 -Port 53 

# LocalUser
Get-LocalUser 

# Active Directory
Get-ADForest 

# (W)MI
Get-CimInstance -ClassName Win32_OperatingSystem 