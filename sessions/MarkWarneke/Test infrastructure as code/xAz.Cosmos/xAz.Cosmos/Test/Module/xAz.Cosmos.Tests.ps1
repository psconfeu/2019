<#
.SYNOPSIS
    Gets all PowerShell files and trys to parse them
.DESCRIPTION
   Gets all PowerShell files that match *.ps1, *.psm1, *.psd1  in ModuleBase  and trys to parse them
   Will try to import the module cleanly
#>


###############################################################################
# Dot source the import of module
###############################################################################
. $PSScriptRoot\shared.ps1

Describe "General project validation: $moduleName"  -Tag Build {

    $scripts = Get-ChildItem $ModuleBase -Include *.ps1, *.psm1, *.psd1 -Recurse

    # TestCases are splatted to the script so we need hashtables
    $testCase = $scripts | Foreach-Object {@{file = $_}}
    It "Script <file> should be valid powershell" -TestCases $testCase {
        param($file)

        $file.fullname | Should Exist

        $contents = Get-Content -Path $file.fullname -ErrorAction Stop
        $errors = $null
        $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
        $errors.Count | Should Be 0
    }

    It "Module '$moduleName' can import cleanly" {
        {Import-Module (Join-Path $ModuleBase "$moduleName.psm1") -force } | Should Not Throw
    }
}

