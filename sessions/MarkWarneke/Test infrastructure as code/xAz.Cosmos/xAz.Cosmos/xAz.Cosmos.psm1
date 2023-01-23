[cmdletbinding()]
param(

)

Write-Verbose $PSScriptRoot


<#
    Load Common Helper
    https://github.com/PowerShell/DscResources/blob/master/StyleGuidelines.md#localization
#>

Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath 'CommonResourceHelper.psm1')
Write-Verbose -Message "Imported CommonResourceHelper.psm1"

$script:localizedData = Get-LocalizedData -ResourceName 'localization'
Write-Verbose -Message "Load localizedData"

<#
    Load functions
#>
Write-Verbose -Message  "Import everything in sub folders public, private, classes folder"
$functionFolders = @('Public', 'Private', 'Classes')
ForEach ($folder in $functionFolders) {
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder

    If (Test-Path -Path $folderPath) {

        Write-Verbose -Message "Importing from $folder"
        $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1'
        ForEach ($function in $functions) {
            Write-Verbose -Message "Importing $($function.BaseName)"
            . $($function.FullName)
        }
    }
}

$publicFunctions = (Get-ChildItem -Path "$PSScriptRoot\Public" -Filter '*.ps1').BaseName
Write-Verbose -Message "Export Public Functions"
Export-ModuleMember -Function $publicFunctions