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

    Describe "New-Component function unit tests" -Tags Unit {

        Mock Get-AzResourceGroup { return @{ResourceGroupName = $TestValues.ResourceGroupName } } -ModuleName xAz.Cosmos

        $Exception = $null
        try {
            $InputObject = @{
                ResourceName      = $TestValues.ResourceName
                ResourceGroupName = $TestValues.ResourceGroupName
                Location          = $TestValues.Location
            }

            $cosmos = New-xAzCosmosDeployment @InputObject -WhatIf
        }
        catch {
            $Exception = $_
        }

        It "should not throw" {
            $Exception | should be $null
        }

        it "should have resourcename" {
            $cosmos.ResourceName | Should Be $TestValues.ResourceName
        }

        Assert-MockCalled Get-AzResourceGroup -ModuleName xAz.Cosmos -Times 1
    }

}