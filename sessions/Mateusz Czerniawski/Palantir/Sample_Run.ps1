#Import Modules
Import-Module  WEFTools -Force
Import-Module  PSWinReportingV2 -Force


#region Get Current Definition List
Get-WEDefinitionList

<#
Will result in list of current `definition files`:

ADComputerCreatedChanged
ADComputerDeleted
ADGroupChanges
ADGroupCreateDelete
ADPasswordChange
ADUserAccountEnabledDisabled
ADUserCreateDelete
ADUserLocked
ADUserUnlocked
LogClearSecurity
LogClearSystem
OSCrash
OSStartupShutdownCrash
OSStartupShutdownDetailed
#>

#endregion

#region Run all definitions
#Search for events from 1 Past Day. DateTime Parameters are derived from PSWinDocumentation!


$GetEventFromWECSplat = @{
    Times               = 'CurrentDayMinuxDaysX'
    Days                = 1
    WECacheExportFile   = 'C:\AdminTools\Cache.json'
    Verbose             = $true
    PassThru            = $true
}
$Events = Get-EventFromWEC @GetEventFromWECSplat

#endregion

#region Run only specific Definitions
$WEDefinitionSet = @('ADUserAccountEnabledDisabled','ADPasswordChange',
                     'LogClearSecurity','LogClearSystem',
                     'OSCrash','OSStartupShutdownCrash','OSStartupShutdownDetailed'
                     )
$Events = foreach ($definition in $WEDefinitionSet) {
    $GetEventFromWECSplat = @{
        WEDefinitionName    = $definition
        Times               = 'CurrentDayMinuxDaysX'
        Days                = 1
        Verbose             = $true
        PassThru            = $true
    }
    Get-EventFromWEC @GetEventFromWECSplat
}
$Events
#endregion

#region View all definitions in Out-Grid windows
$Keys = $Events.GetEnumerator() | Select-Object -ExpandProperty Keys
foreach ($k in $Keys) {
    $Events.$k | Out-GridView -Title $k
}
#endregion

#region Use Cache and Azure Log

#- Get last success export time from cache file.
#- Set search date FROM based on cache for given definition and TO as current
#- If found export events to Azure Logs
#- Update cache file with LastRunTime (now) and LastExporTime (if succeeded) for given definition

Import-Module WEFTools -Force
$GetEventFromWECSplat = @{
    WriteToAzureLog     = $true
    ALTableIdentifier   = 'WECLogs' #Name of Table in Azure Log Analytics
    ALWorkspaceID       = 'e2920363-b001-482a-adfc-740e696ff801'
    WorkspacePrimaryKey = 'cGNQmJJ/8E7ea9Cl/AnXGTHFiMfrzbZgPC24ShjaW4pOrJVLSCQYFIAdN00cjfR/PvDXABfxLf2ypcHlm5zq7A=='
    WECacheExportFile   = 'C:\AdminTools\CacheTest.json'
    PassThru    = $true
}
$Events =  Get-EventFromWEC @GetEventFromWECSplat

#endregion

#region View all definitions in Out-Grid windows
$Keys = $Events.GetEnumerator() | Select-Object -ExpandProperty Keys
foreach ($k in $Keys) {
    $Events.$k | Out-GridView -Title $k
}
#endregion

#region View cache file content
Get-WECacheData -WECacheExportFile C:\admintools\Cache.json

<# 
The result will look like this:

DefinitionName               LastExportStatus LastRunTime         LastSuccessExportTime
--------------               ---------------- -----------         ---------------------
ADComputerCreatedChanged     Success          22.05.2019 10:00:10 22.05.2019 10:00:10
ADGroupChanges               Success          27.05.2019 12:50:48 27.05.2019 12:50:48
ADGroupCreateDelete          Success          27.05.2019 12:51:03 27.05.2019 12:51:03
ADPasswordChange             Success          27.05.2019 12:51:14 27.05.2019 12:51:14
ADUserAccountEnabledDisabled Success          27.05.2019 12:51:25 27.05.2019 12:51:25
ADUserCreateDelete           Success          22.05.2019 10:41:53 22.05.2019 10:41:53
LogClearSecurity             Success          24.05.2019 13:42:57 24.05.2019 13:42:57
LogClearSystem               Success          24.05.2019 13:42:59 24.05.2019 13:42:59
OSStartupShutdownCrash       Success          27.05.2019 14:56:50 27.05.2019 14:56:50
OSStartupShutdownDetailed    Success          27.05.2019 14:56:57 27.05.2019 14:56:57
#>
#endregion
