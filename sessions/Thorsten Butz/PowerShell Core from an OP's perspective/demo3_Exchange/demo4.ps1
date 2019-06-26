# Exchange: Implicit remoting
Import-PSSession -Session (New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri 'http://sea-mx1.contoso.com/PowerShell/')
Get-Command -Name Get-Mailbox 
$MSXModule = 'tmp_igsvanw4.i5q' # This will change from session to session 

# Check unapproved verbs
$ApprovedVerbs = (Get-Verb).Verb
$Cmdlets = Get-Command -Name '*-*' -CommandType cmdlet, function -WarningAction SilentlyContinue -ErrorAction SilentlyContinue -Module $MSXModule 

$result = foreach ($item in $Cmdlets) {
    if ($ApprovedVerbs -notcontains (Get-Command -Name $item).Verb) {
        Get-Command -Name $item
    }    
} 
$result | Format-Table -Property CommandType, Name, Version, Source, Visibility    

# One mor thing
Get-Command -Name Remove-Cal*