function Remove-Hope {
    [CmdletBinding(
        SupportsShouldProcess
    )]
    param (
        
    )

    if ($PSCmdlet.ShouldProcess("Abandon all hope, ye who enter here")) {
        Write-Warning "Welcome to hell!"
    }
}

$output = Remove-Hope -WhatIf
$output -eq $null

function Invoke-DryRun {
    [CmdletBinding(
        SupportsShouldProcess
    )]
    param (
        [switch]$DryRun
    )

    if ($DryRun) {
        [ordered]@{
            First = 'Capture'
            Later = 'Profit!'
        }
    } else {
        if ($PSCmdlet.ShouldProcess("For realz!")) {
            Invoke-SomeAction
        }
    }
}

$output = Invoke-DryRun -DryRun
$output | ConvertTo-JsonEx