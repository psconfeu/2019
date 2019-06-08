#REQUIRES -Version 5.0
#REQUIRES #-Modules
#REQUIRES #-RunAsAdministrator
function Get-Name {
    <#
        .SYNOPSIS
        Get the name by naming convention

        .DESCRIPTION
        Get the name by naming convention

        .EXAMPLE
        Get-xAz.CosmosName -Environment 'P'
        Generates naming conveniton:'P'

        .PARAMETER Environment
        Name of Environment - e.g. S
        [ValidateSet("P", "I", "D", "S", "T")]

        .PARAMETER Description
        Additional info you want to add as a name

        .PARAMETER Delimiter
        Delimiter if needed
    #>

    [CmdletBinding(
        PositionalBinding = $True
    )]
    [OutputType([String])]
    param(

        [Parameter(
            Mandatory = $true,
            Position = 0,
            HelpMessage = "Environment - e.g. S"
        )]
        [ValidateSet("P", "I", "D", "S", "T")]
        [Alias("Env")]
        [string] $Environment,

        [Parameter(
            Mandatory = $false,
            HelpMessage = "Delimiter if needed"
        )]
        [string]
        [ValidatePattern("(\-|\s)")] # matches dash or space
        [ValidateLength(1, 1)]
        $Delimiter = "-",

        [string]
        $Description = 'markpsconf2019'
    )

    begin {
        [int] $CHARACTER_NAME_LIMIT = 100
    }

    process {

        if ([string]::IsNullOrEmpty($Environment)) {
            throw 'Invalid Parameter Exception: Please specify Environment'
        }

        $ComponentName = ("{1}{0}{2}" -f $Delimiter, $Environment.ToLower(), $Description.ToLower())

        $ComponentName = Remove-Delimiter $ComponentName $Delimiter
        Test-CharacterLength $ComponentName $CHARACTER_NAME_LIMIT

        Write-Verbose  "[$(Get-Date)] Created ComponentName $ComponentName"
        Write-Output $ComponentName
    }
}

function Remove-Delimiter {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "Does not change state")]
    [CmdletBinding()]
    param (
        $ComponentName,
        $Delimiter
    )

    process {

        if ($ComponentName[$ComponentName.Length - 1] -eq $Delimiter) {
            Write-Verbose "[$(Get-Date)] Remove trailing Delimiter"
            $ComponentName = $ComponentName.Substring(0, $ComponentName.Length - 1)
        }

        $ComponentName
    }
}

function Test-CharacterLength {
    [CmdletBinding()]
    param (
        $ComponentName,
        $CharacterLengthLimit
    )
    process {
        if ($CharacterLengthLimit) {
            if ($ComponentName.Length -gt $CharacterLengthLimit) {
                throw "To many characters $ComponentName, Limit is $CharacterLengthLimit"
            }
        }
    }
}
