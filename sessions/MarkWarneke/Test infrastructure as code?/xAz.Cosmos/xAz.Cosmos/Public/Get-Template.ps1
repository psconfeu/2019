function Get-Template {
    <#
    .SYNOPSIS
    Returns the link to the modules ARM template

    .DESCRIPTION
    Returns the link to the modules ARM template
    Can be configured in Modulemanifest (xAz.Cosmos.psd1)  Attribute FileList = @('./static/azuredeploy.json')

    .EXAMPLE
    Get-xAz.CosmosArmTemplate

    C:~>\xAz.Cosmos\static\azuredeploy.json

    #>
    [CmdletBinding()]
    param (

    )

    begin {
    }

    process {
        $moduleFileList = $Local:MyInvocation.MyCommand.Module.FileList
        $TemplateUri = $moduleFileList[0]
        $TemplateUri
    }

    end {
    }
}
