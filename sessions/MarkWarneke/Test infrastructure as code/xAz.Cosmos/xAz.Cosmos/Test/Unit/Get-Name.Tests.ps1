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

    Describe "Get-Name function unit tests" -Tags Unit {

        $name = Get-xAzCosmosName -Environment $TestValues.Environment -Description $TestValues.Descriptor

        it "should match name $($TestValues.ResourceNameTest)" {
            $name | Should Be $TestValues.ResourceNameTest
        }

    }

    Describe "Get-Name function unit tests - validation" -Tags Unit {

        $TestCases = @(
            @{
                Environment = 'FAIL'
                Expected    = 'Environment'
            },
            @{
                Environment = 'F'
                Expected    = 'Environment'
            }
        )
        it "Given <Environment> as Environment - should throw an exception containing <Expected>" -TestCases $TestCases {
            param(
                $Environment,
                $Expected
            )
            {
                $InputObject = @{
                    Environment = $Environment
                }
                Get-xAzCosmosName @InputObject -WhatIf
            } | Should Throw $Expected
        }

    }
}