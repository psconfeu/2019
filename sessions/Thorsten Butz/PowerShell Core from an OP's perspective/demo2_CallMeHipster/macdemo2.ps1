# Create remote session (SSH!)
$SSHSession1 = New-PSSession -HostName 'sea-sv2' -UserName 'admin01@contoso.com'
# Remove-PSSession -Session $SSHSession1

Invoke-Command -Session $SSHSession1 -ScriptBlock { hostname }
Invoke-Command -Session $SSHSession1 -ScriptBlock { 
    Get-ADDomain | Select-Object -Property DNSRoot, DomainMode
}

# Proxy commands
$proxymodule = Import-PSSession -Session $SSHSession1 -Module ActiveDirectory 
Get-Module
# Remove-Module -Name $proxymodule    
Get-ADDomain | Select-Object -Property DNSRoot, DomainMode
Get-ADOrganizationalUnit -Filter * | Select-Object -Property DistinguishedName 

New-ADOrganizationalUnit -Name 'Hannover' -ProtectedFromAccidentalDeletion $false
# Remove-ADOrganizationalUnit -Identity 'OU=Hannover,DC=contoso,DC=com' -Confirm:$false 

#########################
# Lets create some users
#########################

$agenda = Invoke-RestMethod -uri 'powershell.fun'  
$agenda | Where-Object -FilterScript { $_.Speaker -eq 'Thorsten Butz' } 
$ou = 'OU=Hannover,DC=contoso,DC=com'
$agenda |  
    Where-Object -FilterScript { $_.Track -eq 'Track 3' -and $_.twitter }| 
        Sort-Object -Property Speaker -Unique | 
            ForEach-Object {
                [PSCustomObject]@{    
                    Company = $_.Company 
                    SamAccountName  =  $_.twitter 
                    GivenName = $_.Speaker.split()[0]
                    Surname = $_.Speaker.split()[-1]
                    Description = $_.Name 
                    Name = $_.Speaker
                    Displayname = $_.Speaker
                    Office = $_.Track
                    City = 'Hannover'
                } 
} | New-ADUser -Path $ou -Enabled $true 

# Get results
$props = 'SamAccountName', 'GivenName', 'Surname', 'Name', 'Office', 'City','Company'
Get-ADUser -Filter { Office -eq 'Track 3'} -Properties $props | Format-Table -AutoSize -Property $props 