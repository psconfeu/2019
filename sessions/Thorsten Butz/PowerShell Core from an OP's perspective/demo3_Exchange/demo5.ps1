# Remove-Module -Name $proxymodule    
Get-ADOrganizationalUnit -Filter * | Select-Object -Property DistinguishedName 
$ou = 'OU=Hannover,DC=contoso,DC=com'

#############################
# Lets create some mailboxes
#############################

$agenda = Invoke-RestMethod -uri 'powershell.fun'  
$agenda |  
    Where-Object -FilterScript { $_.Track -eq 'Track 1' -and $_.twitter }| 
        Sort-Object -Property Speaker -Unique |
            ForEach-Object {
                $params = @{    
                    Alias  =  $_.twitter 
                    Firstname = $_.Speaker.split()[0]
                    Lastname = $_.Speaker.split()[-1]
                    Name = $_.Speaker
                    UserPrincipalName = $_.twitter + '@contoso.com'
                    OrganizationalUnit = $ou
                    Password = ConvertTo-SecureString -AsPlainText -Force -String 'Pa$$w0rd'
                } 
               New-Mailbox @params -ErrorAction SilentlyContinue
            }

# Get-Mailbox -OrganizationalUnit $ou | Remove-Mailbox -Force
