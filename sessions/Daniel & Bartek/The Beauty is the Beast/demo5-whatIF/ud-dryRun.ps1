# Two endpoints, one to read, one to update. How do we control permissions?

function Get-GroupSid {
    <#
            .Synopsis
            Looks up group (specified by name) and returns SID in format that HasClaims() accepts it.

            .Description
            Helper function. Performs following steps:
            - looks up group in AD
            - converts objectSid in S-* format

            .Example
            Get-GroupSid -Name Domain Users

            Returns string representation of Domain Users SID.
    #>
    [OutputType([String])]
    [CmdletBinding()]
    param (
        # Name of the group that should be converted into SID.
        [Parameter(Mandatory)]
        [String]$Name
    )

    $searcher = [ADSISearcher]::new(
        "(name=$Name)",
        @(
            'name'
            'objectSid'
        )
    )

    try {
        $searcher.FindAll().ForEach{
            [Security.Principal.SecurityIdentifier]::new(
                $_.Properties['objectSid'][0],
                0
            ).Value
        }
    } catch {
        throw "Failed to get SID for group $Name - $_"
    }
}

$claimsMap = @{
    FileRead = Get-GroupSid -Name UDRegularGroup
    FileModify = Get-GroupSid -Name UDAdminGroup
}

$authPolicies = @(
    New-UDAuthorizationPolicy -Name FileRead -Endpoint {
        param ($ClaimsPrinciple)
        $ClaimsPrinciple.HasClaim(
            'http://schemas.microsoft.com/ws/2008/06/identity/claims/groupsid',
            $claimsMap.FileRead
        )
    }
    New-UDAuthorizationPolicy -Name FileModify -Endpoint {
        param ($ClaimsPrinciple)
        $ClaimsPrinciple.HasClaim(
            'http://schemas.microsoft.com/ws/2008/06/identity/claims/groupsid',
            $claimsMap.FileModify
        )
    }
)


$fileReadEndpoint = New-UDEndpoint -Method GET -Url '/file' -Endpoint {
    (Get-Content -Path "C:\Repositories\BeautyBeast\demo4-authorization-and-authentication\testfile.txt" -Raw).ToString() | ConvertTo-Json
} -AuthorizationPolicy FileRead


$fileModifyEndpoint = New-UDEndpoint -Method POST -Url '/file' -Endpoint {
    Add-Content -Path "C:\Repositories\BeautyBeast\demo4-authorization-and-authentication\testfile.txt" -Value 'PSCONFEU Rocks!'
} -AuthorizationPolicy FileModify

$fileRemoveDryRun = New-UDEndpoint -Method GET -Url /removeFile -Endpoint {
    @{
        Action = 'Remove'
        Path = "C:\Repositories\BeautyBeast\demo5-whatIF\testfile.txt"
    } | ConvertTo-Json
} -AuthorizationPolicy FileModify

Start-UDDashboard -Content {
    $Auth = New-UDAuthenticationMethod -Windows
    $LoginPage = New-UDLoginPage -AuthenticationMethod @($Auth) -AuthorizationPolicy $authPolicies -PassThru

    New-UDDashboard -Title WIA -Content { 
        New-UDRow -Columns {
            New-UDColumn -Size 12 -Endpoint {
                New-UDCard -Text "Logged in as $user"
            }
        }
    } -LoginPage $LoginPage
} -Wait -AllowHttpForLogin -Endpoint @(
    $fileReadEndpoint
    $fileModifyEndpoint
    $fileRemoveDryRun
)