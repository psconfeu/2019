<#
    .Synopsis
    Script that sends information about build result to the API(s).

    .Description
    In the final step of the build we are able to see what was the build result.
    This script is used to send this information to any API that is willing to listen.
    Following conditions apply:
    - $env:bamboo_buildFailed is used to figure out result
    - $env:bamboo_buildResultKey is used to get last errors from the log
    - $env:bamboo_repository_branch_name is used to verify that we are looking at master build and not at some user-branch build

    .Example
    Send-BuildResult.ps1
    Uses build-in variables to send information about the build result.
#>
[CmdletBinding()]
param (
    # Name of the repository where script is running
    [Parameter(Mandatory)]
    [String]$Repository,

    # Uri to API that should handle our data
    [String]$ApiUri = 'http://localhost:10000/api/events'

)

# Hardcoded for demo, usually this data comes from the $env_Bamboo environment variables.
$branch = 'master'
$buildFailed = [bool]::Parse('False')

if ($branch -notin 'master', 'test') {
    exit 0
}

$message = 'Build {0} {1}' -f @(
    'DSC-1337'
    $(if ($buildFailed) { 'failed' } else { 'succeeded' })
)

try {
    Invoke-RestMethod -Method Post -Uri $apiUri -Body @{
        Failed = $buildFailed
        Message = $message
        Branch = $branch
        Repository = $Repository
    } -ErrorAction Stop
} catch {
    Write-Error "Failed to send information to the API $ApiUri - $_"
}
