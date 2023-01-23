###########################################
# Enable RSAT in Windows 10-1809 and later
# Requires Internet connection
###########################################

Get-WindowsCapability -Online -Name rsat* | Add-WindowsCapability -Online 
Get-WindowsCapability -Online -Name rsat* | Select-Object -Property DisplayName, State