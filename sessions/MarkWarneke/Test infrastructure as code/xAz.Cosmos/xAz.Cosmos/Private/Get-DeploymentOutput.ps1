
function Get-DeploymentOutput {
    <#
        .SYNOPSIS
            Takes Outputs from Arm Template deployment and generates a pscustomobject.

        .PARAMETER Deployment
            Deployment return from New-AzResourceGroupDeployment

        .PARAMETER ErrorMessage
            Return error message of New-AzResourceGroupDeployment

        .EXAMPLE
        Get-DeploymentOutput -Deployment $Deployment -ErrorMessage $ErrorMessages

        Format deployment and error messages if passed

        .NOTES
            Outputs is Dictionary  needs enumerator
            Output value has odd value key again -> $output.Value.Value

            [DBG]: PS C:> $output

            Key              Value
            ---              -----
            virtualMachineId Microsoft.Azure.Commands.ResourceManager.Cmdlets.SdkModels.DeploymentVariable

            [DBG]: PS C:> $output.Value

            Type   Value
            ----   -----
            String /subscriptions/<subscription>/resourceGroups/<resourceGroup>/providers/Microsoft.<Proivder>/<Resource>/<Value>

            $output.value.value
    #>
    [CmdletBinding()]
    param(
        $Deployment,
        $ErrorMessage
    )

    if ($ErrorMessages) {
        Write-Output '', 'Template deployment returned the following errors:', @(@($ErrorMessages) |
                ForEach-Object {
                $_.Exception.Message.TrimEnd("`r`n")
            })
        return
    }

    if (-Not $Deployment) {
        Write-Error "[$(Get-Date)] Deployment output can not be parsed _n $Deployment"
        return
    }
    else {
        try {
            $return = [PSCustomObject]@{}
            $enum = $Deployment.Outputs.GetEnumerator()

            while ($enum.MoveNext()) {
                $current = $enum.Current
                $return | Add-Member -MemberType NoteProperty -Name $current.Key -Value $current.Value.Value
            }
            $return
        }
        catch {
            Write-Verbose "[$(Get-Date)] Unable to parse"
            return $Outputs
        }
    }
}

