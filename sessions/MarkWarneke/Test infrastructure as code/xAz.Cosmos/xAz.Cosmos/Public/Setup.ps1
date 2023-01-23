function Setup {
    <#
    .SYNOPSIS
    Sets up a Azure Cosmos DB given configuration

    .DESCRIPTION
    Sets up a Azure Cosmos DB given configuration

    .PARAMETER ConfigFile
    Configuration file to add parameters to setup

    .EXAMPLE
    xAzCosmosSetup  -ConfigFile $file

    Creates a cosmos db

    #>

    [CmdletBinding()]
    param (
        # This is the config file
        [Parameter(Mandatory)]
        [string]
        $configFile
    )

    process {

        Write-Verbose "Getting config from $configFile"
        $null = Test-Path $ConfigFile -ErrorAction Stop
        $config = (Get-Content  -Raw ($ConfigFile)) | ConvertFrom-Json

        $null = New-AzResourceGroup -Name $config.ResourceGroupName -Location $config.Location -Force -ErrorAction SilentlyContinue

        $ResourceName = Get-xAzCosmosName -Environment $config.Environment

        $param = @{
            ResourceName        = $ResourceName
            ResourceGroupName   = $config.ResourceGroupName
            Location            = $config.Location
            DeploymentParameter = $config.DeploymentParameter
        }

        New-xAzCosmosDeployment @Param
    }
}