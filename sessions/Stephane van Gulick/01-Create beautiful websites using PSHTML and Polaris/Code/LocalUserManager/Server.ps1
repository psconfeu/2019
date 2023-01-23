<#
    Run this script, and a website will open which allows to list current Local adminis, and add / or remove new ones, using PowerShell ONLY
#>
set-Location $PSScriptRoot

import-module Polaris
Import-Module PSHTML
import-module Microsoft.PowerShell.LocalAccounts

New-PolarisStaticRoute -RoutePath "/styles" -FolderPath "./Styles" -Force

.\Routes\index.ps1
.\Routes\RemoveUser.ps1
.\Routes\Query.ps1
.\Routes\AddUser.ps1

$App = Start-Polaris -Port 8080 -Verbose
start http://localhost:8080/index