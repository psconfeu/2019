#RUN from ARC-OVF server

#region Set variables
Import-Module pChecksAD -Force
Import-Module Pester -force

#$Password = ConvertTo-SecureString "LS1setup!" -AsPlainText -Force
#$Credential = New-Object System.Management.Automation.PSCredential('ARCONTEST\Administrator',$Password)
#$Credential | Export-Clixml -Path C:\admintools\Creds.xml 

$Credential = Import-Clixml -Path C:\admintools\Creds.xml
$queryParams = @{
    #IF Provided will query only this computer!
    #ComputerName  = Get-ADDomainController -Discover -Service PrimaryDC | Select-Object -ExpandProperty HostName
    Credential = $Credential

}
#endregion

#region prepare folders
$BaselineConfigurationFolder = 'C:\AdminTools\Tests\BaselineAD'
if(-not (Test-Path $BaselineConfigurationFolder)) {
    New-Item -Path $BaselineConfigurationFolder -force -ItemType Directory
}
$Baseline = New-pChecksBaselineAD @queryParams
Export-pChecksBaselineAD -BaselineConfiguration $Baseline -BaselineConfigurationFolder $BaselineConfigurationFolder

$ReportsFolder = 'C:\admintools\Tests\Reports'
if(-not (Test-Path $ReportsFolder)) {
    New-Item -Path $ReportsFolder -force -ItemType Directory
}
#endregion

#region Operational Checks - simple
Import-Module pChecksAD -Force
$invokepChecksSplat = @{
    Tag             = @('Operational')
    Verbose         = $true
    Credential      = $Credential
    Show            = 'All'    
}
Invoke-pChecksAD @invokepChecksSplat
#endregion

#region Operational Checks
Import-Module pChecksAD -Force
$invokepChecksSplat = @{
    Tag             = @('Operational')
    #TestTarget     = 'Nodes'
    #NodeName       = @('S1DC1','S1DC2')
    FilePrefix     = 'PSConf-ArconTest'
        IncludeDate    = $true
        OutputFolder   = $ReportsFolder
    Verbose         = $true
    Credential      = $Credential
    Show            = 'All'
    WriteToEventLog = $true
        EventSource     = 'pChecksAD'
        EventIDBase     = 1000
    
}
Invoke-pChecksAD @invokepChecksSplat
#endregion

#region Configuration Checks
$invokepChecksSplat = @{
    Tag             = @('Configuration')
    BaselineConfigurationFolderPath = $BaselineConfigurationFolder
    Verbose         = $true
    Credential      = $Credential
    Show            = 'All'
  
}
Invoke-pChecksAD @invokepChecksSplat
#endregion

#region Azure Log Checks - DEPLOY AZURE LOG ANALYTICS WORKSPACE FIRST
$invokepChecksSplat = @{
    Verbose         = $true
    Credential      = $Credential
    Show            = 'All'
    WriteToAzureLog = $true
       Identifier   = 'pChecksAD'
       CustomerId   = 'e2920363-b001-482a-adfc-740e696ff801'
       SharedKey    = 'cGNQmJJ/8E7ea9Cl/AnXGTHFiMfrzbZgPC24ShjaW4pOrJVLSCQYFIAdN00cjfR/PvDXABfxLf2ypcHlm5zq7A=='
}
Invoke-pChecksAD @invokepChecksSplat
#endregion

#region Full Splat
$invokepChecksSplat = @{
    pChecksIndexFilePath = 'C:\Repos\Private-GIT\pChecksAD\pChecksAD\Index\AD.Checks.Index.json'
    pChecksFolderPath = 'C:\Repos\Private-GIT\pChecksAD\pChecksAD\Checks\'
    Tag= @('Operational')
    TestType = 'Simple'
    TestTarget = 'Nodes'
    NodeName = @('S1DC1','S1DC2')
    FilePrefix = 'YourFileNamePrefix'
    IncludeDate = $true
    OutputFolder = $ReportsFolder
    Verbose = $true
    Credential      = $Credential
    BaselineConfigurationFolderPath = 'C:\AdminTools\Tests\BaselineAD_New' #Adding this means adding tag 'Configuration' $Tag +='Configuration'
    Show            = 'All'
    WriteToEventLog = $true
        EventSource     = 'pChecksAD'
        EventIDBase     = 1000
    WriteToAzureLog = $true
       Identifier          = 'pChecksAD'
       CustomerId          = 'e2920363-b001-482a-adfc-740e696ff801'
       SharedKey           = 'cGNQmJJ/8E7ea9Cl/AnXGTHFiMfrzbZgPC24ShjaW4pOrJVLSCQYFIAdN00cjfR/PvDXABfxLf2ypcHlm5zq7A=='
}
#endregion

#region Generate xml reports

Invoke-pChecksReportUnit -InputFolder $ReportsFolder 

Start-Process msedge.exe -ArgumentList 'C:\admintools\Tests\Reports\Index.html'

#endregion