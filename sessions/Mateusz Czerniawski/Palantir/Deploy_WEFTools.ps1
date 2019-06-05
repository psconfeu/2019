# region [Local] prepare environment variables
$DomainName = 'arcontest.pl'
$FQDNDomainName = 'DC=arcontest,DC=pl'
$TaskScheduleRunner= 'arc-s1wec1.{0}' -f $DomainName
$Credential = Get-Credential
$TaskScheduleRunner = New-PSSession -ComputerName $TaskScheduleRunner -Credential $Credential
#endregion

#region [Remote] configure WEFTools on WEC server
Invoke-Command -Session $TaskScheduleRunner -ScriptBlock {
    Install-Module PSWinReportingV2 -Force
    Install-Module WEFTools -Force

    New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Force
    New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -Force
    New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -name 'Enabled' -value '0xffffffff' –PropertyType DWORD
    New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -name 'DisabledByDefault' -value 0 –PropertyType DWORD
    New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -name 'Enabled' -value 1 –PropertyType DWORD
    New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -name 'DisabledByDefault' -value 0 –PropertyType DWORD
}
#endregion
#region [Remote] configure Task Scheduler on WEC server
Invoke-Command -Session $TaskScheduleRunner -ScriptBlock {
    #$WriteToAzureLog = $true
    $ALTableIdentifier = 'WECLogs'
    $ALWorkspaceID = 'e2920363-b001-482a-adfc-740e696ff801'
    $WorkspacePrimaryKey = 'cGNQmJJ/8E7ea9Cl/AnXGTHFiMfrzbZgPC24ShjaW4pOrJVLSCQYFIAdN00cjfR/PvDXABfxLf2ypcHlm5zq7A=='
    $WECacheFile = 'C:\AdminTools\WEFCache.json'
    $Repeat = 10
    $TaskName = 'WEF Test task'
    $TaskCommand = @"
        Import-Module WEFTools -Force
        `$GetEventFromWECSplat = @{
            WriteToAzureLog     = `$true
            ALTableIdentifier   = '$ALTableIdentifier'
            ALWorkspaceID       = '$ALWorkspaceID'
            WorkspacePrimaryKey = '$WorkspacePrimaryKey'
            WECacheExportFile   = '$WECacheFile'
        }
        Get-EventFromWEC @GetEventFromWECSplat
"@
    $TaskActionSettings = @{
        Execute  = 'powershell.exe'
        Argument = "-ExecutionPolicy Bypass $TaskCommand"
    }
    $TaskAction = New-ScheduledTaskAction @TaskActionSettings
    $TaskTriggerSettings = @{
        Once               = $true
        At                 = (Get-Date).Date
        RepetitionInterval = (New-TimeSpan -Minutes $Repeat)
    }
    $TaskTrigger = New-ScheduledTaskTrigger @TaskTriggerSettings
    $TaskTriggerSettings1 = @{
        AtStartup = $true
    }
    $TaskTrigger1 = New-ScheduledTaskTrigger @TaskTriggerSettings1
    $newScheduledTaskSettingsSetSplat = @{
        StartWhenAvailable         = $true
        RunOnlyIfNetworkAvailable  = $true
        DontStopOnIdleEnd          = $true
        DontStopIfGoingOnBatteries = $true
        AllowStartIfOnBatteries    = $true
    }
    $TaskSetting = New-ScheduledTaskSettingsSet @newScheduledTaskSettingsSetSplat

    $registerScheduledTaskSplat = @{
        Action   = $TaskAction
        RunLevel = 'Highest'
        Trigger  = @($TaskTrigger, $TaskTrigger1)
        TaskName = $TaskName
        Settings = $TaskSetting
        User     = "SYSTEM"
    }
    Register-ScheduledTask @registerScheduledTaskSplat
}
#endregion

$CollectorSession | Remove-PSSession
