$buildMonitorEndpoint = New-UDEndpoint -Url '/events' -Method POST -Endpoint {
    param (
        [Parameter(Mandatory)]
        [String]$Failed,
        [Parameter(Mandatory)]
        [String]$Message,
        [Parameter(Mandatory)]
        [String]$Branch,
        [Parameter(Mandatory)]
        [String]$Repository
    )

    $buildFailed = [bool]::Parse($Failed)

    $eventData = @{
        Message = $Message
        Source = "BuildMonitor $Repository $Branch"
        ErrorAction = 'Stop'
    }

    if ($buildFailed) {
        $eventData.EntryType = 'Error'
        $eventData.EventId = 400
    } else {
        $eventData.EntryType = 'Information'
        $eventData.EventId = 200
    }

    Write-EventLog -LogName Application @eventData
} 

Start-UDRestApi -Endpoint $buildMonitorEndpoint -Port 10000