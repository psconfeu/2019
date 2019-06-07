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
    DnsRead = Get-GroupSid -Name DnsRead
    DnsWrite = Get-GroupSid -Name DnsWrite
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
    New-UDAuthorizationPolicy -Name DnsRead -Endpoint {
        param ($ClaimsPrinciple)
        $ClaimsPrinciple.HasClaim(
            'http://schemas.microsoft.com/ws/2008/06/identity/claims/groupsid',
            $claimsMap.DnsRead
        )
    }
    New-UDAuthorizationPolicy -Name DnsWrite -Endpoint {
        param ($ClaimsPrinciple)
        $ClaimsPrinciple.HasClaim(
            'http://schemas.microsoft.com/ws/2008/06/identity/claims/groupsid',
            $claimsMap.DnsWrite
        )
    }
)


$fileReadEndpoint = New-UDEndpoint -Method GET -Url '/file' -Endpoint {
    (Get-Content -Path "C:\Repositories\BeautyBeast\demo3-authorization-and-authentication\testfile.txt" -Raw).ToString() | ConvertTo-Json
} -AuthorizationPolicy FileRead


$fileModifyEndpoint = New-UDEndpoint -Method POST -Url '/file' -Endpoint {
    Add-Content -Path "C:\Repositories\BeautyBeast\demo3-authorization-and-authentication\testfile.txt" -Value 'PSCONFEU Rocks!'
} -AuthorizationPolicy FileModify

$every5minutes = @{
    Schedule = New-UDEndpointSchedule -Every 5 -Minute
}

$dnsCacheEndpoint = New-UDEndpoint @every5minutes -Endpoint {
    $dnsCache = @{}
    foreach ($zone in 'ud.psconf') {
        $dnsCache[$zone] = @{}
        foreach ($type in 'A', 'CName') {
            $dnsCache[$zone][$type] = @(
                Get-OPDnsRecord -Zone $zone -Type $type -All | 
                    Where-Object { $_.HostName -notlike '*.ud.psconf' }
            )
        }
    }
    foreach ($reverseZone in '1.0.10.in-addr.arpa') {
        $dnsCache[$reverseZone] = @{
            PTR = @(
                Get-OPDnsRecord -Zone $reverseZone -Type Ptr -All
            )
        }
    }
    $cache:dnsCache = $dnsCache
}

$dnsGetARecordApi = New-UDEndpoint -Url /dns/a/:name/:zone -Endpoint {
    param (
        [Parameter(Mandatory)]
        [String]$Name,
        [String]$Zone = 'ud.psconf'
    )

    Write-AuditLog -Parameters $PSBoundParameters
    Get-OPDnsRecord -Name $Name -Zone $Zone -Type A | ForEach-Object {
        @{
            HostName = $_.HostName
            IPAddress = $_.RecordData.IPV4Address
            TimeToLive = "$($_.TimeToLive)"
            Zone = $Zone
        }
    } | ConvertTo-JsonEx
} -AuthorizationPolicy DnsRead

$whoami = New-UDEndpoint -Url /whoami -Endpoint {
    Wait-Debugger
    $ClaimsPrinciple | ConvertTo-JsonEx -Depth 10
}

$dnsGetCnameListHostApi = New-UDEndpoint -Url /dns/cnameListHost/:fqdn -Endpoint {
    param (
        [Parameter(Mandatory)]
        [ValidatePattern('.+\.ud\.psconf$')]
        [String]$Fqdn
    )

    Write-AuditLog -Parameters $PSBoundParameters
    @{
        $Fqdn = @(
            foreach ($zone in 'ud.psconf') {
                $cache:dnsCache[$zone]['CName'].ForEach{
                    if (($_.RecordData.HostNameAlias -replace '\.$') -eq $Fqdn) {
                        "$($_.HostName).$zone"
                    }
                }
            }
        )
    } | ConvertTo-JsonEx
}

$dnsGetCnameSwapApi = New-UDEndpoint -Url /dns/cnameswap -Method GET -Endpoint {
    param (
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter(Mandatory)]
        [String]$Target,
        [String]$Zone = 'ud.psconf',
        [String]$Soft = 'False'
    )

    Write-AuditLog -Parameters $PSBoundParameters
    $noClobber = [bool]::Parse($Soft)

    Move-OPDnsCName -Name $Name -Target $Target -ZoneName $Zone -NoClobber:$noClobber -DryRun | 
        ForEach-Object { [PSCustomObject]$_ } |
        ConvertTo-JsonEx
} -AuthorizationPolicy DnsWrite

$dnsDeleteCnameApi = New-UDEndpoint -Url /dns/cname -Method DELETE -Endpoint {
    param (
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter(Mandatory)]
        [String]$Target,
        [String]$Zone = 'ud.psconf'
    )

    Write-AuditLog -Parameters $PSBoundParameters
    Remove-OPDnsCName -Name $Name -Target $Target -ZoneName $Zone -Confirm:$false
} -AuthorizationPolicy DnsWrite

$dnsPostCnameApi = New-UDEndpoint -Url /dns/cname -Method POST -Endpoint {
    param (
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter(Mandatory)]
        [String]$Target,
        [String]$Zone = 'ud.psconf',
        # ATM Body is sometimes passed to POSTs.. and breaks endpoints with CmdletBinding
        $Body
    )

    Write-AuditLog -Parameters $PSBoundParameters
    New-OPDnsCName -Name $Name -Target $Target -ZoneName $Zone
} -AuthorizationPolicy DnsWrite


$dnsPostCnameSwapApi = New-UDEndpoint -Url /dns/cnameswap -Method POST -Endpoint {
    param (
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter(Mandatory)]
        [String]$Target,
        [String]$Zone = 'ud.psconf',
        [String]$Soft = 'False',
        # ATM Body is sometimes passed to POSTs.. and breaks endpoints with CmdletBinding
        $Body
    )

    Write-AuditLog -Parameters $PSBoundParameters
    $noClobber = [bool]::Parse($Soft)

    Move-OPDnsCName -Name $Name -Target $Target -ZoneName $Zone -NoClobber:$noClobber
} -AuthorizationPolicy DnsWrite


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
    $dnsCacheEndpoint
    $dnsGetARecordApi
    $dnsGetCnameListHostApi
    $dnsGetCnameSwapApi
    $dnsDeleteCnameApi
    $dnsPostCnameApi
    $dnsPostCnameSwapApi
    $whoami
)