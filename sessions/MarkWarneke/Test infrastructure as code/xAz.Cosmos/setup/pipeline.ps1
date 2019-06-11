param (
    $ConfigFile = 'config.psconf.json'
)

$root = $ENV:SYSTEM_DEFAULTWORKINGDIRECTORY
$repoName = $ENV:REPO_NAME # custom variable
$moduleName = $ENV:MODULE_NAME # custom variable

#region join path

# for debugging
if (! $ENV:SYSTEM_DEFAULTWORKINGDIRECTORY) {
    $root = "C:\dev\tmp\powershell"
    $repoName = "xAz.Cosmos"
    $moduleName = "xAz.Cosmos"
}
Get-ChildItem $root -Recurse # For inspecting the working directory
$repoPath = Join-Path $root $repoName
Write-Verbose "RepoPath $repoPath"
$modulePath = Join-Path $repoPath $moduleName
Write-Verbose "modulePath $modulePath"
$moduleManifestPath = Join-Path $modulePath "$moduleName.psd1"
Write-Verbose "moduleManifestPath $moduleManifestPath"
$ConfigFilePath = Join-Path $repoPath "Setup" | Join-Path -ChildPath $ConfigFile
Write-Verbose "ConfigFilePath $ConfigFilePath"
#endregion

Import-Module $moduleManifestPath -PassThru

xAzCosmosSetup -ConfigFile  $ConfigFilePath -Verbose