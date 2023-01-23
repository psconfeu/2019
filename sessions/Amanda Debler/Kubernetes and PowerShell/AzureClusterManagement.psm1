# WARNING: please note the complete lack of error checking.

function Get-AKSHotfixVersion {
    #[cmdletbinding()]
    param(
        #[parameter(
        #Mandatory         = $true,
        #ValueFromPipeline = $true)]
        $AKSCluster)
    $hotfixVersions = @{'14'='1.14.0';'13'='1.13.5';'12'='1.12.8'; '11'='1.11.9'; '10'='1.10.13'; '9'='1.10.13'}
    foreach ($cluster in $AKSCluster) {
        $currentVersion = $cluster.KubernetesVersion
        [string]$majorRelease = $currentVersion.split('.')[1]
        $hotfixVersion = $hotfixVersions.$majorRelease
        $hotfixVersion
    }
}

# If Set-AzAks -KubernetesVersion worked...
function Update-AKSClustersForHotfixPSStyle {
    $clusters = Get-AzAks
    foreach ($cluster in $clusters) {
        $targetVersion = Get-AKSHotfixVersion -AKSCluster $cluster
        Set-AzAks -InputObject $cluster -KubernetesVersion $targetVersion
    }
}

# Updating clusters to the version given by Get-AKSHotfixVersion
function Update-AKSClustersForHotfix {
    $mySubscriptions = $(az account list --query [].id -o tsv)
    foreach ($subscription in $mySubscriptions) {
        $clusters = $(az aks list --subscription $subscription) | ConvertFrom-Json
        foreach ($cluster in $clusters) {
            $targetVersion = Get-AKSHotfixVersion -AKSCluster $cluster
            az aks upgrade --resource-group $($cluster.resourceGroup) --name $($cluster.name) --kubernetes-version $targetVersion --subscription $subscription --no-wait --yes
        }
    }
}

# Checking the Docker runtime version for each cluster - 20 minutes later
function Get-AKSContainerRuntimeVersion {
    $mySubscriptions = $(az account list --query [].id -o tsv)
    foreach ($subscription in $mySubscriptions) {
        $clusters = $(az aks list --subscription $subscription) | ConvertFrom-Json
        foreach ($cluster in $clusters) {
            "$($cluster.name) in resource group $($cluster.resourceGroup) in subscription $subscription"
            az aks get-credentials --resource-group $($cluster.resourceGroup) --name $($cluster.name) --subscription $subscription --overwrite-existing
            #kubectl get nodes -o custom-columns=NAME:.metadata.name,VERSION:.status.nodeInfo.containerRuntimeVersion
            (kubectl get nodes -o json | convertfrom-json).items.status.nodeInfo.containerRuntimeVersion
        }
    }
}
