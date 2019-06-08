<#
.SYNOPSIS

Installes PSSake, if not existing.
Runs psakefile.ps1 with passed parameters
Author: Daniel Scott-Raynsford [Github: CosmosDb](https://github.com/PlagueHO/CosmosDB)

.DESCRIPTION

Installes PSSake, if not existing.
Runs psakefile.ps1 with passed parameters
Author: Daniel Scott-Raynsford [Github: CosmosDb](https://github.com/PlagueHO/CosmosDB)

.PARAMETER TaskList
Specify name of task to run, used in psakefile.ps1

.PARAMETER Parameters
Specify Parameters passed to psakefile.ps1

.PARAMETER Properties
Specify Properties passed to psakefile.ps1

.EXAMPLE

C:\PS> .\psake.ps1 -TaskList Test -Verbose
Run psakefile TaskLists named "Test"

.LINK
https://github.com/PlagueHO/CosmosDB

#>

[CmdletBinding()]
param (
    [Parameter()]
    [System.String[]]
    $TaskList = 'Default',

    [Parameter()]
    [System.Collections.Hashtable]
    $Parameters,

    [Parameter()]
    [System.Collections.Hashtable]
    $Properties
)

Write-Verbose -Message ('Beginning ''{0}'' process...' -f ($TaskList -join ','))

# Bootstrap the environment
$null = Get-PackageProvider -Name NuGet -ForceBootstrap
# Find-PackageProvider   -Name "NuGet" | Install-PackageProvider  -Force -Scope CurrentUser

# Install PSake module if it is not already installed
if (-not (Get-Module -Name PSDepend -ListAvailable)) {
    Install-Module -Name PSDepend -Scope CurrentUser -Force -Confirm:$false
}

# Install build dependencies required for Init task
Import-Module -Name PSDepend
Invoke-PSDepend -Path $PSScriptRoot -Force -Import -Install -Tags 'Bootstrap'

# Execute the PSake tasts from the psakefile.ps1
Invoke-Psake -buildFile (Join-Path -Path $PSScriptRoot -ChildPath 'psakefile.ps1') -nologo @PSBoundParameters

exit ( [int]( -not $psake.build_success ) )
