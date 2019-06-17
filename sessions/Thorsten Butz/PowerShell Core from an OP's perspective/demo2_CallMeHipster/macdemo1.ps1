# Overview: MacOS 10.14.2 (Mojave)
$PSVersionTable
(Get-Command -Name '*-*' -CommandType Cmdlet, Function).count 

# SSH: check connectivity 
Get-Command -Name 'Test-*Connection' 
Test-Connection -ComputerName 'sea-sv2' -TCPPort 22 

# "Generic" ssh connection: uses Registry Key to start the subsystem
ssh 'admin01@contoso.com@sea-sv2'

# PowerShell remoting: uses SSHD_conclsfig to determine the subsystem
Enter-PSSession -HostName 'sea-sv2' -UserName 'admin01@contoso.com'    

################
# @ REMOTE HOST
###############

# Load profile
. 'C:\pwsh\6\profile.ps1'

# Check configuration on the REMOTE HOST
psedit 'C:\demo\DefaultShellRegistry.ps1' # "Default ssh connections"
psedit 'C:\ProgramData\ssh\sshd_config'   # PS Remoting: Enter-Pssession ...

# Wtf ... is 'c:\pwsh' ??
Get-Item -Path 'c:\pwsh' |  Format-Table -Property Mode, Name, Linktype, Target, Attributes
psedit 'C:\demo\CreatePWSHJunction.ps1'