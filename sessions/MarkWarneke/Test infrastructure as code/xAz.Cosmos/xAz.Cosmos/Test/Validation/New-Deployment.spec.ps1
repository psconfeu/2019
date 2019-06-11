[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Variables are used inside Pester blocks.")]
param(
    [string[]]$TestValueFiles
)

###############################################################################
# Dot source the import of module
###############################################################################
. $PSScriptRoot\shared.ps1


if ($PSBoundParameters.Keys -notcontains 'TestValueFiles') {
    $TestValueFiles = (Get-Childitem -Path (Join-Path $ModuleBase "Test") -Include "config.*.json" -Recurse).FullName
}

Foreach ($TestValueFile in $TestValueFiles) {

    $Env:TestValueFile = $TestValueFile
    $TestValues = Get-Content $TestValueFile | ConvertFrom-Json

    Describe "Validate Deployment" -Tag Validate {
        Context "CosmosDb Example" {

            # Query Azure - you can test what you get @SQLDBWithABeard
            $resource = Get-AzResource -ResourceType 'Microsoft.DocumentDB/databaseAccounts' -ResourceGroupName $TestValues.ResourceGroupName -ErrorAction SilentlyContinue

            It "Should have name" {
                $resource.Name | Should Be $TestValues.ResourceName
            }

            It "Should have location" {
                $resource.Location | Should Be $TestValues.Location
            }
        }
    }
}