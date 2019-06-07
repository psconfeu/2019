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

function Write-AuditLog {
    <#
        .Synopsis
        A very thin wrapper around Write-OPEventLog that logs audit information for UD API endpoints.

        .Description
        Function that logs following from each UD endpoint call:
        - user
        - user agent
        - path
        - method
        - parameters
        Information is recorded in UDAudit provider in Optiver log.
        Only parameters can be specified - everything else is taken from the parent scope.

        .Example
        Write-AuditLog -Parameters $PSBoundParameters
        Write information about API call complete with parameters captured.
    #>
    param (
        [hashtable]$Parameters
    )
    $message = @{
        User = $User
        UserAgent = $Request.Headers['User-Agent']
        Path = $Request.Path.Value
        Method = $Request.Method
        Parameters = $Parameters
    } | ConvertTo-JsonEx
    Write-EventLog -LogName Application -Source UDAudit -EntryType Information -Message $message -EventId 100
}

$claimsMap = @{
    FileRead = Get-GroupSid -Name UDRegularGroup
    FileModify = Get-GroupSid -Name UDAdminGroup
}

$dashboardInit = New-UDEndpointInitialization -Function @(
    'Write-AuditLog'
)

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


$fileReadEndpoint = New-UDEndpoint -Method GET -Url '/file/:name' -Endpoint {
    param (
        [Parameter(Mandatory)]
        $Name,
        $Body
    )
    Write-AuditLog -Parameters $PSBoundParameters
    (Get-Content -Path "C:\Repositories\BeautyBeast\demo6-audit\$Name.txt" -Raw).ToString() | ConvertTo-Json
} -AuthorizationPolicy FileRead


$fileModifyEndpoint = New-UDEndpoint -Method POST -Url '/file/:name' -Endpoint {
    param (
        [Parameter(Mandatory)]
        $Name,
        $Body
    )
    Write-AuditLog -Parameters $PSBoundParameters
    Add-Content -Path "C:\Repositories\BeautyBeast\demo6-audit\$Name.txt" -Value 'PSCONFEU Rocks!'
} -AuthorizationPolicy FileModify

$fileRemoveDryRun = New-UDEndpoint -Method GET -Url /removeFile/:name -Endpoint {
    param (
        [Parameter(Mandatory)]
        $Name,
        $Body
    )
    Write-AuditLog -Parameters $PSBoundParameters
    @{
        Action = 'Remove'
        Path = "C:\Repositories\BeautyBeast\demo6-audit\$Name.txt"
    } | ConvertTo-Json
} -AuthorizationPolicy FileModify


$fileRemove = New-UDEndpoint -Method DELETE -Url /removeFile -Endpoint {
    param (
        [Parameter(Mandatory)]
        $Name,
        $Body
    )
    Write-AuditLog -Parameters $PSBoundParameters
    Remove-Item -Path "C:\Repositories\BeautyBeast\demo6-audit\$Name.txt"
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
    } -LoginPage $LoginPage -EndpointInitialization $dashboardInit
} -Wait -AllowHttpForLogin -Endpoint @(
    $fileReadEndpoint
    $fileModifyEndpoint
    $fileRemoveDryRun
    $fileRemove
)