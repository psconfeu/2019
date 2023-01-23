#http://chen.about-powershell.com/2018/10/auto-refresh-polaris-page-to-retrieve-status-using-pshtml/

<#
Combining PSHTML with Polaris show all existing Services using an autorefresh

Start/Stop one or more services from the list while this is running, to see them switch to their new statue, with the correct coller.

This demo was not played, simply to have enough time to everything else.
#>

using Module Polaris
Import-module PSHTML -force

New-PolarisGetRoute -Path "/Service" -Scriptblock {
    #import-module pshtml -force
    $HTML = html {
        head {
            Title "Auto Refresh"
            meta -httpequiv "refresh" -content "10"
        }
        body {
            hr 
            h1 "Get-Service"
            hr 
            Table -Content {
                tr -Content {
                    Th -Content "Name"
                    Th -Content "Status"
                }
                tr -Content {
                    foreach ($Service in (Get-Service | Select -First 10)) {
                        tr -Content {
                            td -Content {
                                $Service.Name
                            }
                            if ($Service.Status -eq "Running") {
                                td -Content {
                                    $Service.Status
                                } -Style "color:GREEN"
                            }
                            else {
                                td -Content {
                                    $Service.Status
                                } -Style "color:RED"
                            }
                        }
                    }
                } -Id "customers" -Attributes @{"border"="1"}
            } 
        } -Style "font-family:Candara"
    }
    $Response.SetContentType('text/html')
    $Response.Send($HTML)
}


Start-Polaris -Port 8080

start "http://localhost:8080/Service"