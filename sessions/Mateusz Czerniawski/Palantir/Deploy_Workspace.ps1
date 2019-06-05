New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Force
New-Item 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -Force
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -name 'Enabled' -value '0xffffffff' –PropertyType DWORD
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -name 'DisabledByDefault' -value 0 –PropertyType DWORD
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -name 'Enabled' -value 1 –PropertyType DWORD
New-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -name 'DisabledByDefault' -value 0 –PropertyType DWORD

Install-Module AzureRm
Import-Module AzureRm
Connect-AzureRmAccount

#Select subscription where Log Analytics workspace should be created


Get-AzureRmSubscription | Out-GridView -PassThru | Select-AzureRmSubscription

$resourceGroupName = 'RG-LogAnalytics'
$Location = 'westeurope'
$workspaceSKU = 'standalone'
$workspaceName = 'LA-PSConf'

$newAzureRmResourceGroupSplat = @{
    Name = $resourceGroupName
    Location = $Location
}
New-AzureRmResourceGroup @newAzureRmResourceGroupSplat

$newWorkspaceSplat = @{
    ResourceGroupName = $resourceGroupName
    Location = $location
    Sku = $workspaceSKU
    Name = $workspaceName
}

New-AzureRmOperationalInsightsWorkspace @newWorkspaceSplat

$WorkspacePrimaryKey = Get-AzureRmOperationalInsightsWorkspaceSharedKeys -ResourceGroupName $resourceGroupName -Name $workspaceName | Select-Object -ExpandProperty PrimarySharedKey

$WorkspacePrimaryKey

$ALWorkspaceID = Get-AzureRmOperationalInsightsWorkspace -ResourceGroupName $resourceGroupName -Name $workspaceName | Select-Object -ExpandProperty CustomerId | Select-Object -ExpandProperty Guid
$ALWorkspaceID

$WorkspaceData = @{
    PrimaryKey = $WorkspacePrimaryKey
    WorkspaceID = $ALWorkspaceId
}

$WorkspaceDataPath = 'c:\AdminTools\Workspace.dat'
$WorkspaceData | Export-CLIXml -path $WorkspaceDataPath

$WorkspaceDataPath = 'c:\AdminTools\Workspace.dat'
$WorkspaceData =Import-CLIXml -path $WorkspaceDataPath
