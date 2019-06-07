function Write-AuditLog {
    <#
        .Synopsis
        A very thin wrapper around Write-EventLog that logs audit information for UD API endpoints.

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
