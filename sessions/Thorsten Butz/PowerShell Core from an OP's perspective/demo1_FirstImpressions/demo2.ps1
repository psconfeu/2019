# Counting Cmdlets
(Get-Command -Name *-* -CommandType Cmdlet, Function).count  
Get-Module      

# Where are my favourite cmdlets? 
Get-Command -Name Get-LocalUser
Get-Command -Name Get-ADForest
Get-Command -Name 'Test-*Connection'

# Networking
Test-Connection -ComputerName sea-dc1 

# LocalUser
Import-Module -Name 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\Microsoft.PowerShell.LocalAccounts' -SkipEditionCheck
Get-LocalUser 

# Active Directory
Import-Module -Name 'C:\Windows\System32\WindowsPowerShell\v1.0\Modules\ActiveDirectory' -SkipEditionCheck

# WMI
Get-CimInstance -ClassName Win32_OperatingSystem 