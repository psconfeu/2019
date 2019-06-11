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

    Describe "New-Component function integration tests" -Tags Integration, Build {

        BeforeAll {
            # Create test environment
            $ResourceGroupName = 'TT-' + (Get-Date -Format FileDateTimeUniversal)
            Write-Host "Creating test environment $ResourceGroupName..."
            Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue | Remove-AzResourceGroup -Force

            $ResourceName = 'psconf-' + $ResourceGroupName.ToLower()
            $null = New-AzResourceGroup -Name $ResourceGroupName -Location 'WestEurope'
        }

        AfterAll {
            # Remove test environment
            Write-Host "Removing test environment $ResourceGroupName..."
            Get-AzResourceGroup -Name $ResourceGroupName | Remove-AzResourceGroup -Force -AsJob
        }

        $Exception = $null
        try {
            $InputObject = @{
                ResourceName      = $ResourceName
                ResourceGroupName = $ResourceGroupName
                Location          = $TestValues.Location
            }

            $cosmos = New-xAzCosmosDeployment @InputObject -Verbose
        }
        catch {
            $Exception = $_
        }

        It "should not throw" {
            $Exception | should be $null
        }

        it "should have... " {
            $cosmos.ResourceName | Should Be $ResourceName
        }

    }

}