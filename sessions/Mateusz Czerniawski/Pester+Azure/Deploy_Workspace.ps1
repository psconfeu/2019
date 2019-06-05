#region [Local]

Install-Module AzureRm
Import-Module AzureRm
Connect-AzureRmAccount

#Select subscription where Log Analytics workspace should be created
Get-AzureRmSubscription | Out-GridView -PassThru | Select-AzureRmSubscription
#region New Resource Group
$resourceGroupName = 'RG-LogAnalyticsTest'
$Location = 'westeurope'
$workspaceSKU = 'standalone'
$workspaceName = 'LA-PSConfTest'

$newAzureRmResourceGroupSplat = @{
    Name = $resourceGroupName
    Location = $Location
}
New-AzureRmResourceGroup @newAzureRmResourceGroupSplat
#endregion
#region New Insight Workspace
$newWorkspaceSplat = @{
    ResourceGroupName = $resourceGroupName
    Location = $location
    Sku = $workspaceSKU
    Name = $workspaceName
}

New-AzureRmOperationalInsightsWorkspace @newWorkspaceSplat

#endregion

#region Show Workspace ID and Key
$PrimarySharedKey = Get-AzureRmOperationalInsightsWorkspaceSharedKeys -ResourceGroupName $resourceGroupName -Name $workspaceName | Select-Object -ExpandProperty PrimarySharedKey
$PrimarySharedKey

$CustomerID = Get-AzureRmOperationalInsightsWorkspace -ResourceGroupName $resourceGroupName -Name $workspaceName | Select-Object -ExpandProperty CustomerId | Select-Object -ExpandProperty Guid
$CustomerID

$WorkspaceData = @{
    PrimarySharedKey = $PrimarySharedKey
    CustomerID = $CustomerID
}

$WorkspaceDataPath = 'c:\AdminTools\Workspace.dat'
$WorkspaceData | Export-CLIXml -path $WorkspaceDataPath

$WorkspaceDataPath = 'c:\AdminTools\Workspace.dat'
$WorkspaceData =Import-CLIXml -path $WorkspaceDataPath

#endregion
