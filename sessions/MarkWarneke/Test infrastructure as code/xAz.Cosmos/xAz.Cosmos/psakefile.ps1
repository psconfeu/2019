[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingConvertToSecureStringWithPlainText", "")]
param()

<#
.SYNOPSIS
PSake makes variables declared here available in other scriptblocks

.DESCRIPTION
- Init: set location and enumerate environment details
- PrepareTest: [installs dependencies]
- Test
    - ModuleTest: Executes per module /test
    - UnitTest: Executes per module /test -Tag Unit
    - IntegrationTest: Executes per module /test/integration
PSake makes variables declared here available in other scriptblocks

.EXAMPLE

C:\PS> .\psakefile.ps1 -TaskList Test -Verbose
Run psake TaskLists named "Test"
#>

# Init some things
Properties {
    # Prepare the folder variables
    if (-not $ProjectRoot) {
        $ProjectRoot = $PSScriptRoot
    }

    $ModuleBase = @('.')
    Write-Verbose "$ModuleBase"

    $Timestamp = Get-Date -uformat "%Y%m%d-%H%M%S"
    Write-Verbose "$Timestamp"
    $separator = '----------------------------------------------------------------------'
    Write-Verbose "$separator"
}

Task Default -Depends Test

Task Init {
    Set-Location -Path $ProjectRoot

    # Install any dependencies required for the Init stage
    Invoke-PSDepend -Path $PSScriptRoot -Force -Import -Install -Tags 'Init'

    $separator
    'Other Environment Variables:'
    Get-ChildItem -Path ENV:
    "`n"

    $separator
    'PowerShell Details:'
    $PSVersionTable
    "`n"
}

Task PrepareTest -Depends Init {
    # Install any dependencies required for testing
    Invoke-PSDepend -Path $PSScriptRoot -Force -Import -Install -Tags 'Test'

    foreach ($module in $ModuleBase) {
        # Execute tests
        $moduleRoot = Join-Path -Path $ProjectRoot -ChildPath $module
        $testScriptsPath = Join-Path -Path $moduleRoot -ChildPath 'test'
        . Join-Path $testScriptsPath "Shared.Tests.ps1"
    }
}

Task Test -Depends ModuleTest, UnitTest#, IntegrationTest

Task ModuleTest -Depends Init, PrepareTest {
    $separator

    foreach ($module in $ModuleBase) {
        # Execute tests
        $moduleRoot = Join-Path -Path $ProjectRoot -ChildPath $module
        $testScriptsPath = Join-Path -Path $moduleRoot -ChildPath 'test\Module'
        $testResultsFile = Join-Path -Path $ProjectRoot -ChildPath 'TestResults.module.xml'

        $pester = @{
            Script       = $testScriptsPath
            OutputFormat = 'NUnitXml'
            OutputFile   = $testResultsFile
            PassThru     = $true
            ExcludeTag   = 'Incomplete, Unit'
        }
        $null = Invoke-Pester @pester
    }

    "`n"
}

Task UnitTest -Depends Init, PrepareTest {
    $separator

    foreach ($module in $ModuleBase) {
        # Execute tests
        $moduleRoot = Join-Path -Path $ProjectRoot -ChildPath $module
        $testScriptsPath = Join-Path -Path $moduleRoot -ChildPath 'Test\Unit'
        $testResultsFile = Join-Path -Path $ProjectRoot -ChildPath 'TestResults.unit.xml'
        # $codeCoverageFile = Join-Path -Path $ProjectRoot -ChildPath 'CodeCoverage.xml'

        $pester = @{
            Script       = $testScriptsPath
            OutputFormat = 'NUnitXml'
            OutputFile   = $testResultsFile
            PassThru     = $true
            Tag          = 'Unit'
            ExcludeTag   = 'Incomplete'
            # CodeCoverage                 = $codeCoverageSource
            # CodeCoverageOutputFile       = $codeCoverageFile
            # CodeCoverageOutputFileFormat = 'JaCoCo'
        }
        $null = Invoke-Pester @pester

    }
    "`n"
}

Task IntegrationTest -Depends Init, PrepareTest {
    $separator

    foreach ($module in $ModuleBase) {
        # Execute tests
        $moduleRoot = Join-Path -Path $ProjectRoot -ChildPath $module
        $testScriptsPath = Join-Path -Path $moduleRoot -ChildPath 'Test\Integration'
        $testResultsFile = Join-Path -Path $ProjectRoot -ChildPath 'TestResults.integration.xml'

        if (Test-Path $testScriptsPath) {
            $pester = @{
                Script       = $testScriptsPath
                OutputFormat = 'NUnitXml'
                OutputFile   = $testResultsFile
                PassThru     = $true
                ExcludeTag   = 'Incomplete'
            }
            $null = Invoke-Pester @pester
        }
    }

    "`n"
}

Task Build -Depends Init {
    $separator

    # Install any dependencies required for the Build stage
    Invoke-PSDepend -Path $PSScriptRoot -Force -Import -Install -Tags 'Build'

    # New-MarkdownHelp -Module $ModuleName -OutputFolder (Join-Path -Path $ProjectRoot -ChildPath $DocsFolder) -Force

    # Prepare external help
    'Building external help file'
    New-ExternalHelp -Path (Join-Path -Path $ProjectRoot -ChildPath 'docs\en-US') -OutputPath . -Force

}

Task PrePublish {
    Write-Verbose "Update PowerShellGet"
    Update-Module "PowerShellGet" -Force -Verbose
    Update-Module "PackageManagement" -Force -Verbose

    Import-Module "PowerShellGet" -Force
    Import-Module "PackageManagement" -Force

    $feedurl = $feedurl -f $organization, $feedName
    Set-DefinedPSRepository -feedname $feedName -feedurl $feedurl -systemAccessToken $systemAccessToken -queueById $queueById
}

Task Publish -Depends Init, PrePublish {

    <#
.SYNOPSIS
Build the current powershell module as an artifact and push it to a designated feed

.DESCRIPTION
This method adjusts the module's manifest in two ways:
 - It assigns a new given or generated module version to the manifest
 - It extracts all public functions from this module and lists them in the manifest

 Subsequently it pushes the module as an artifact to a corresponding module feed as a nuget package where it can be downloaded from.

.PARAMETER feedName
Name of the feed to push the module to. By default it's 'Release-Modules'

.PARAMETER feedurl
Optional feedurl to set by pipeline. Use {0} in path to specify the feedname
e.g. "https://apps-custom.pkgs.visualstudio.com/_packaging/{0}/nuget/v2"

.PARAMETER customVersion
If the new version should not be generated you can specify a custom version. It must be higher than the latest version inside the module feed.

.PARAMETER systemAccessToken
Personal-Access-Token provieded by the pipeline or user to interact with the module feed

.PARAMETER queueById
Name/Email/Id of the user interacting with the module feed

.PARAMETER test
An optional parameter used by tests to only run code that is required for testing

.EXAMPLE
$(Build.SourcesDirectory)\$(module.name)\Pipeline\build.ps1 -systemAccessToken = "1235vas3" -queueById "testUser@myUser.org"

Execute the build.ps1 to push a module with the next available version to the default module feed 'Release-Modules'

.EXAMPLE
$(Build.SourcesDirectory)\$(module.name)\Pipeline\build.ps1 -feedname "Pipeline-Modules" -systemAccessToken = "1235vas3" -queueById "testUser@myUser.org" -customVersion "2.0.0"

Execute the build.ps1 to push a module with the desired version 2.0.0 to the module feed 'Pipeline-Modules'
#>

    $separator

    if (-not $moduleName) {
        Write-Warning "No module name found, assume modulebase $moduleBase"
        $moduleName = $moduleBase
    }

    if (-not $organization) {
        Write-Error "please enter organization of Azure Devops"
    }

    if (-not $feedName) {
        Write-Error "please enter feed name of Azure DevOps Artifakts"
    }

    if (-not $systemAccessToken) {
        Write-Error "please enter system access token of Azure DevOps Artifakts"
    }

    if (-not $feedurl) {
        Write-Error "please enter  Azure DevOps feed url placeholder"
    }

    if (-not $queueById) {
        Write-Error "please enter queue by id"
    }

    $oldPreferences = $VerbosePreference
    $VerbosePreference = "Continue"

    try {

        $moduleBase = Join-Path $PSscriptRoot $moduleName
        $moduleName = Split-Path $moduleBase -Leaf

        Write-Verbose "Module Root $moduleRoot"
        Write-Verbose "Module Name $moduleName"

        $feedurl = $feedurl -f $organization, $feedName
        Write-Verbose "Feed-Url: $feedurl"

        $password = ConvertTo-SecureString $systemAccessToken -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential ($queueById, $password)

        $currentVersion = Get-CurrentVersion -feedname $feedName -moduleName $moduleName -credential $credential
        Write-Verbose "Current version is $currentVersion"

        $newVersion = Get-NewVersion -currentVersion $currentVersion

        # $newVersion = New-Object System.Version("{0}.{1}.{2}" -f 1, 1, 0)
        Write-Verbose "New version is $newVersion"

        Set-LocalVersion -newVersion $newVersion -moduleName $moduleName -moduleBase $moduleBase
        Write-Verbose "Updated local version to $newVersion"

        Update-ManifestExportedFunction  -moduleName $moduleName -moduleBase $moduleBase

        Test-ModuleManifest -Path (Join-Path $moduleBase "$moduleName.psd1") | Format-List

        Publish-NuGetModule -feedname $feedname -credential $credential -moduleName $moduleName -moduleBase $moduleBase
    }
    finally {
        $VerbosePreference = $oldPreferences
    }

}

#region functions

<#
    .SYNOPSIS
        Generate a new version number.
#>
function Get-VersionNumber {
    [CmdLetBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ManifestPath,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Build
    )

    # Get version number from the existing manifest
    $manifestContent = Get-Content -Path $ManifestPath -Raw
    $regex = '(?<=ModuleVersion\s+=\s+'')(?<ModuleVersion>.*)(?='')'
    $matches = @([regex]::matches($manifestContent, $regex, 'IgnoreCase'))
    $version = $null

    if ($matches) {
        $version = $matches[0].Value
    }

    # Determine the new version number
    $versionArray = $version -split '\.'
    $newVersion = ''

    foreach ($ver in (0..2)) {
        $sem = $versionArray[$ver]

        if ([String]::IsNullOrEmpty($sem)) {
            $sem = '0'
        }

        $newVersion += "$sem."
    }

    $newVersion += $Build
    return $newVersion
}


<#
    .SYNOPSIS
        Safely execute a Git command.
#>
function Invoke-Git {
    [CmdLetBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String[]]
        $GitParameters
    )

    try {
        "Executing 'git $($GitParameters -join ' ')'"
        exec { & git $GitParameters }
    }
    catch {
        Write-Warning -Message $_
    }
}

function Get-CurrentVersion {
    <#
.SYNOPSIS
Search for a certain module in the given feed to check it's version.

.DESCRIPTION
Search for a certain module in the given feed to check it's version. If no module can be found, version 0.0.0 is returned

.PARAMETER feedname
Name of the feed to search in

.PARAMETER moduleName
Name of the module to search for

.PARAMETER credential
The credentials required to access the feed

.EXAMPLE
$currentVersion = Get-CurrentVersion -moduleName "aks" -feedname "moduleFeed" -credential $credential

Search for module AKS in the feed moduleFeed to receive its version
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $feedname,
        [Parameter(Mandatory = $true)]
        [string] $moduleName,
        [Parameter(Mandatory = $true)]
        [PSCredential] $credential
    )

    Write-Verbose "Get Module"

    Get-PSRepository
    nuget sources
    $credential.UserName

    $module = Find-Module -Name $moduleName -Repository $feedname -Credential $credential -ErrorAction SilentlyContinue
    if ($module) {
        return $module.Version
    }
    else {
        Write-Warning "Module $moduleName not found"
        Write-Verbose "Assume first deployment"
        return New-Object System.Version("0.0.0")
    }
}

function Get-NewVersion {
    <#
.SYNOPSIS
Get a new version object

.DESCRIPTION
Generate a new version or return the custom version as a version object if set

.PARAMETER customVersion
The optionally set custom version

.PARAMETER currentVersion
The current version of the module

.EXAMPLE
Get-NewVersion -customVersion 0 -currentVersion 0.0.4

Get the new version 0.0.5

.EXAMPLE
Get-NewVersion -customVersion 0.0.6 -currentVersion 0.0.4

Get the new version 0.0.6
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [version] $currentVersion
    )

    $build = $currentVersion.Build
    $minor = $currentVersion.Minor
    $major = $currentVersion.Major

    if ($build -lt 65000) { $build++ }
    elseif ($minor -lt 65000) { $minor++ }
    else {
        throw "Minor and Build Versions exceeded. Run a build with a new custom major version. (e.g. 2.x.x)"
    }

    $newVersion = New-Object System.Version("{0}.{1}.{2}" -f $major, $minor, $build)

    return $newVersion
}

function Publish-NuGetModule {

    <#
.SYNOPSIS
Publish a given module to specified feed

.DESCRIPTION
Publish a given module to specified feed

.PARAMETER feedname
Nanm of the feed to push to

.PARAMETER credential
Credentials required by the feed

.EXAMPLE
Publish-NuGetModule -feedname "Release-Modules" -credential $credential -moduleName "Aks"

Push the module AKS to the feed 'Release-Modules'
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $feedname,
        [Parameter(Mandatory = $true)]
        [PSCredential] $credential,
        [Parameter(Mandatory = $true)]
        [string] $moduleBase,
        [Parameter(Mandatory = $true)]
        [string] $moduleName
    )

    try {
        Write-Verbose "Try pushing module $moduleName from $moduleBase"

        #nuget spec $moduleName

        #nuget pack "$moduleName.nuspec"

        #nuget push -Source $feedname -ApiKey AzureDevOpsServices "$moduleName*.nupkg"

        Publish-Module -Path "$moduleBase" -NuGetApiKey 'AzureDevOpsServices' -Repository $feedname -Credential $credential -Force -Verbose
        Write-Verbose "Published module"
    }
    catch {
        Write-Verbose ("Unable to  upload module {0}" -f (Split-Path $PSScriptRoot -Leaf))
        $_.Exception | format-list -force
        throw $_
    }
}
function Set-LocalVersion {
    <#
.SYNOPSIS
Set the specified version to the module manifest

.DESCRIPTION
Set the specified version to the module manifest

.PARAMETER newVersion
The version to set

.PARAMETER moduleBase
The root folder of the module

.PARAMETER moduleName
The name of the module

.EXAMPLE
Set-LocalVersion -newVersion $newVersion -moduleBase "c:\modules\aks" -moduleName "aks"

Set the provided moduleVersion to the manifest of module aks in the folder 'c:\modules\aks'
#>
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [version] $newVersion,
        [Parameter(Mandatory = $true)]
        [string] $moduleBase,
        [Parameter(Mandatory = $true)]
        [string] $moduleName
    )

    $modulefile = Join-Path $moduleBase "$moduleName.psd1"
    if ($PSCmdlet.ShouldProcess("Module manifest", "Update")) {
        Update-ModuleManifest -Path $modulefile -ModuleVersion $newVersion
    }
}

function Update-ManifestExportedFunction {
    <#
.SYNOPSIS
Add the module's public functions to its manifest

.DESCRIPTION
Extracts all functions in the module's public folder to add them as 'FunctionsToExport' int he manifest

.PARAMETER moduleBase
The root folder of the module

.PARAMETER moduleName
The name of the module

.EXAMPLE
Update-ManifestExportedFunction  -moduleBase "c:\modules\aks" -moduleName "aks"

Add all public functions of module AKS to its manifest
#>
    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [string] $moduleBase,
        [Parameter(Mandatory = $true)]
        [string] $moduleName
    )

    $publicFunctions = (Get-ChildItem -Path (Join-Path $moduleBase "Public") -Filter '*.ps1').BaseName

    $modulefile = Join-Path $moduleBase "$moduleName.psd1"
    if ($PSCmdlet.ShouldProcess("Module manifest", "Update")) {
        Write-Verbose "Update Manifest $moduleFile"
        Update-ModuleManifest -Path $modulefile -FunctionsToExport $publicFunctions
    }
}


function Set-DefinedPSRepository {
    <#
    .SYNOPSIS
    Add a given repository as a source for modules
    .DESCRIPTION
    Add a given repository as a source for modules
    .PARAMETER feedurl
    Url to the feed to add
    .PARAMETER systemAccessToken
    Access token required to access the feed
    .PARAMETER queueById
    Id/Email of the instance that wants to access the feed
    .EXAMPLE
    Set-DefinedPSRepository -feedname "Release-Modules" -feedurl $feedurl -systemAccessToken $systemAccessToken -queueById $queueById
    Set the feed Release-Modules as a nuget and repo source with the specified credentials
    #>

    [CmdletBinding(
        SupportsShouldProcess = $true
    )]
    param (
        [Parameter(Mandatory = $true)]
        [string] $feedname,
        [Parameter(Mandatory = $true)]
        [string] $feedurl,
        [Parameter(Mandatory = $true)]
        [string] $systemAccessToken,
        [Parameter(Mandatory = $true)]
        [string] $queueById
    )

    Write-Verbose "Feed-Url: $feedurl"

    Write-Verbose 'Add nuget source definition'
    $nugetSources = nuget sources
    if (!("$nugetSources" -Match $feedName)) {
        nuget sources add -name $feedname -Source $feedurl -Username $queueById -Password $systemAccessToken
    }
    else {
        Write-Verbose "NuGet source $feedname already registered"
    }
    Write-Verbose 'Check registered repositories'
    $regRepos = (Get-PSRepository).Name
    if ($regRepos -notcontains $feedName) {
        if ($PSCmdlet.ShouldProcess("PSRepository", "Register new")) {
            Write-Verbose 'Registering script folder as Nuget repo'
            Register-PSRepository $feedname -SourceLocation $feedurl -PublishLocation $feedurl -InstallationPolicy Trusted
            Write-Verbose "Repository $feedname registered"
        }
    }
    else {
        Write-Verbose "Repository $feedname already registered"
    }

    Write-Verbose ("Available repositories:")
    Get-PSRepository
}


#endregion

