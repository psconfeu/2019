<#
.SYNOPSIS
    Dot source this script in any Pester test script that requires the module to be imported.
    Import the module into the current file

.DESCRIPTION
    Import the module into the current file
    uses current invovation info ($PSScriptRoot) to query for the modules base
    If current file is located in 'Module' it will set the base to the parent
    If current  file is located in 'Test' it will set the base to the parent
    Will split to leaf as Module Parent Folder Name must match Module Name
    If running on the build server the leaf is equal to "s", will use ModuleName as Build Server env virable.
    Will remove the found module
    and import it cleanly again

.OUTPUTS
    $ModulBase = Root path of the module
    $leaf = Name of the module
    $ModuleName = Name of the module
    $Module = Imported Module

.EXAMPLE
    PS C:\> . $PSScriptRoot\shared.ps1
    Imports the module into the current file

#>

$ModuleBase = Split-Path -Parent $MyInvocation.MyCommand.Path

# For tests in .\Integration subdirectory
if ((Split-Path $ModuleBase -Leaf) -eq 'Integration') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}

# For tests in .\Unit subdirectory
if ((Split-Path $ModuleBase -Leaf) -eq 'Unit') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}

# For tests in .\Module subdirectory
if ((Split-Path $ModuleBase -Leaf) -eq 'Module') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}
# For tests in .\Tests subdirectory
if ((Split-Path $ModuleBase -Leaf) -eq 'Test') {
    $ModuleBase = Split-Path $ModuleBase -Parent
}

# Handles modules in version directories
$leaf = Split-Path $ModuleBase -Leaf
$parent = Split-Path $ModuleBase -Parent
$parsedVersion = $null
if ([System.Version]::TryParse($leaf, [ref]$parsedVersion)) {
    $ModuleName = Split-Path $parent -Leaf
}
# for VSTS build agent
elseif ($leaf -eq 's') {
    $ModuleName = $Env:Build_Repository_Name
}
else {
    $ModuleName = $leaf
}

# Removes all versions of the module from the session before importing
Get-Module $ModuleName | Remove-Module

# Because ModuleBase includes version number, this imports the required version
# of the module
$ModuleManifestPath = Join-Path $ModuleBase "$ModuleName.psd1"

$Module = Import-Module $ModuleManifestPath -PassThru -ErrorAction Stop

if (!$SuppressImportModule) {
    # -Scope Global is needed when running tests from inside of psake, otherwise
    # the module's functions cannot be found in the xAz.KV\ namespace
    Import-Module $ModuleManifestPath -Scope Global
}

Write-Verbose "end  import $module"
