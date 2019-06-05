$DomainName = 'arcontest.pl'
$OVFServer= 'arc-ovf.{0}' -f $DomainName
$Credential = Get-Credential
$OVFSession = New-PSSession -ComputerName $OVFServer -Credential $Credential

#region [Remote] [OVF] Install modules
Invoke-Command -Session $OVFSession -ScriptBlock {
    Get-WindowsFeature -name *RSAT* | Add-WindowsFeature -IncludeManagementTools
    Install-Module pChecksAD
    Install-Module Pester -SkipPublisherCheck -Force
}
#endregion

#region [Remote] [OVF] configure TLS
Invoke-Command -Session $OVFSession -ScriptBlock {
    New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Force
    New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -Force
    New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -name 'Enabled' -value '0xffffffff' –PropertyType DWORD
    New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -name 'DisabledByDefault' -value 0 –PropertyType DWORD
    New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -name 'Enabled' -value 1 –PropertyType DWORD
    New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -name 'DisabledByDefault' -value 0 –PropertyType DWORD
}
#endregion

#region [Remote] [OVF] configure folders
Invoke-Command -Session $OVFSession -ScriptBlock {
    New-Item -ItemType Directory -Path 'c:\AdminTools\'
}
#endregion

#region [Remote] [OVF] prepare Task File
Invoke-Command -Session $OVFSession -ScriptBlock {
$FileContent = @"
$Password = ConvertTo-SecureString "LS1setup!" -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential('ARCONTEST\Administrator',$Password)
#$Credential = Import-Clixml -Path C:\admintools\Creds.xml
#$BaselineConfigurationFolder = 'C:\AdminTools\Tests\BaselineAD'
$ReportsFolder = 'C:\admintools\Tests\Reports'
$invokepChecksSplat = @{
    #pChecksIndexFilePath = 'C:\Repos\Private-GIT\pChecksAD\pChecksAD\Index\AD.Checks.Index.json'
    #pChecksFolderPath = 'C:\Repos\Private-GIT\pChecksAD\pChecksAD\Checks\'
    Tag= @('Operational')
    #TestType = 'Simple'
    #TestTarget = 'Nodes'
    #NodeName = @('S1DC1','S1DC2')
    FilePrefix     = 'PSConf-ArconTest'
    IncludeDate    = $true
    OutputFolder   = $ReportsFolder
    Verbose = $true
    Credential      = $Credential
    #CurrentConfigurationFolderPath = $BaselineConfigurationFolder #Adding this means adding tag 'Configuration' $Tag +='Configuration'
    Show            = 'All'
    WriteToEventLog = $true
        EventSource     = 'pChecksAD'
        EventIDBase     = 1000
    WriteToAzureLog = $true
       Identifier          = 'pChecksAD'
       CustomerId          = 'e2920363-b001-482a-adfc-740e696ff801'
       SharedKey           = 'cGNQmJJ/8E7ea9Cl/AnXGTHFiMfrzbZgPC24ShjaW4pOrJVLSCQYFIAdN00cjfR/PvDXABfxLf2ypcHlm5zq7A=='
}

Invoke-pChecksAD @invokepChecksSplat
"@
$FileContent | Out-File 'C:\AdminTools\pChecksAD_Run.ps1'
}

#region [Remote] configure Task Scheduler on OVF server
Invoke-Command -Session $OVFSession -ScriptBlock {
    #$WriteToAzureLog = $true
    $Repeat = 60
    $TaskName = 'pChecksAD'
    $TaskCommand = @"
        C:\AdminTools\pChecksAD_Run.ps1
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





