<#
    Explanation of what Polaris is
#>

#Polaris basics
    #Minimal web framework for PowerShell

#Install Polaris
    Find-Module Polaris | install-Module

#First step

Import-Module polaris

New-PolarisGetRoute -Path "/helloworld" -Scriptblock {
    $Response.Send('Hello World!')
}

Start-Polaris


$HelloWorldURL = "http://localhost:8080/helloworld"

start $HelloWorldURL

New-PolarisGetRoute -Path "/Processes" -Scriptblock {
    $RunningProcesses = Get-Process | select ProcessName,CPU,Id -First 5 | ConvertTo-Html -Title "Processes" | Out-String
    $Response.SetContentType("text/html")
    $Response.Send($RunningProcesses)
 }


start "http://localhost:8080/Processes"