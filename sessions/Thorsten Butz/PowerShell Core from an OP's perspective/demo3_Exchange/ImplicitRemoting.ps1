###################
# Implict Remoting
###################

# Create Credentials object
$cred = [System.Management.Automation.PSCredential]::new('admin01@contoso.com', (ConvertTo-SecureString -AsPlainText -Force -String 'Pa$$w0rd'))
Test-WSMan -ComputerName sea-dc1 -Credential $cred -Authentication Kerberos

# Active Directory
$PSSession1 = New-PSSession -ComputerName sea-dc1 -Credential $cred
Invoke-Command -Session $PSSession1 -ScriptBlock { Get-ADDomain }

# "Proxy" 
$ProxyModule = Import-PSSession -Session $PSSession1 -Module ActiveDirectory 
Get-ADDomain

# Exchange 
$PSSession2 = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri 'http://sea-mx1.contoso.com/PowerShell/' -Credential $cred -Authentication Kerberos
$ProxyModule2 = Import-PSSession $PSSession2
Get-Mailbox

# Clean up
Remove-Module -Name $ProxyCommands,$ProxyModule2
Remove-PSSession -Session $psSession1, $psSession2