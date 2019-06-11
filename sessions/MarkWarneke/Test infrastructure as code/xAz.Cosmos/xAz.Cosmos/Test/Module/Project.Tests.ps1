<#
.SYNOPSIS
    Runs script analyzer ruls on all PowerShell files found in ModuleBase
.DESCRIPTION
   Runs script analyzer ruls on all PowerShell files that match *.ps1, *.psm1, *.psd1  in ModuleBase and all child folders.
   Invokes all rules from script analyzer execpt those specified in Test.Exceptions.txt
   Will try to import the module cleanly
#>

###############################################################################
# Dot source the import of module
###############################################################################
. $PSScriptRoot\shared.ps1

# Excludes list of files
$FunctionHelpTestExceptions = Get-Content -Path (Join-Path $PSScriptRoot "Test.Exceptions.txt")

Describe "PSScriptAnalyzer rule-sets" -Tag Build , ScriptAnalyzer {

    $Rules = Get-ScriptAnalyzerRule
    $scripts = Get-ChildItem $ModuleBase -Include *.ps1, *.psm1, *.psd1 -Recurse | Where-Object fullname -notmatch 'classes'

    foreach ( $Script in $scripts ) {
        if ($FunctionHelpTestExceptions -contains $Script.Name) { continue }
        Context "Script '$($script.FullName)'" {

            foreach ( $rule in $rules ) {
                # Skip all rules that are on the exclusions list
                if ($FunctionHelpTestExceptions -contains $rule.RuleName) { continue }
                It "Rule [$rule]" {

                    (Invoke-ScriptAnalyzer -Path $script.FullName -IncludeRule $rule.RuleName ).Count | Should Be 0
                }
            }
        }
    }
}


Describe "General project validation: $moduleName" -Tags Build {
    BeforeAll {
        Get-Module $ModuleName | Remove-Module
    }
    It "Module '$moduleName' can import cleanly" {
        { Import-Module $ModuleBase\$ModuleName.psd1 -force } | Should Not Throw
    }
}


