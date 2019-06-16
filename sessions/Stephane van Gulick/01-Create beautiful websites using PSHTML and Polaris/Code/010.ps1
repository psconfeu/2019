<#
    This is an example using everything all together (Chart, Powershell logic and Boostrap integration).
    This example was actually NOT in my presentation, as I needed to remove some stuff, to make the presentation a bit less long :)
#>

$BarCanvasID = "barcanvas"
$HTML = html { 
    head {
        title 'Assets'
        Write-PSHTMLAsset -Name Jquery
        Write-PSHTMLAsset -Name BootStrap
        Write-PSHTMLAsset -Name Chartjs
    }
    body {
        div -Class "Container" {
            h1 "PSHTML Graph"

            div {
            
                p {
                    "This is a bar Chart"
                }
                canvas -Height 400px -Width 400px -Id $BarCanvasID {
    
                }

                $AllServices = get-Service |  ? { $_.StartType -eq 'automatic'} | sort Name
                $StoppedServicesCount = ($AllServices | ? {$_.Status -eq 'stopped'}).count
                $RunningServicesCount = ($AllServices | ? {$_.Status -eq 'Running'}).Count

                h2 "Summary"

                ul -Class "list-group d-inline-flex p-3" -Content {
                    li -Class "list-group-item d-flex justify-content-between align-items-center list-group-item-danger" -content {
                        "Stopped"
                        span "badge badge-primary badge-pill" -Content $StoppedServicesCount
                    }
                    li -Class "list-group-item d-flex justify-content-between align-items-center list-group-item-success" -content {
                        "Running"
                        span "badge badge-primary badge-pill" -Content $RunningServicesCount
                    }
                }


                h2 "Details"
                
                    ul -Class "list-group" -content {
                        
                        foreach($Service in $AllServices){

                            if($Service.Status -ne 'running'){
                                
                                #<span class="badge badge-danger">Danger</span>
                                $AlertType = "badge badge-danger"
                                $Message = "Danger"
                                
                            }else{
                                $AlertType = "badge badge-success"
                                $Message = "Ok"
                            }
                            
                            li -Class "list-group-item" -content {

                                "The service $($Service.Name) is currently $($Service.Status)"
                                span -Class $AlertType -Content "$($Message)"
                            }
                            
                            
                        }
                    }
                }
                

            }

            script -content {


                $Data3 = @(4, 1, 6, 12, 17, 25, 18, 17, 22, 30, 35, 44)
                $Labels = @("January", "February", "Mars", "April", "Mai", "June", "July", "August", "September", "October", "November", "december")

                $dsb3 = New-PSHTMLChartBarDataSet -Data $data3 -label "2018" -BackgroundColor 'blue'

                New-PSHTMLChart -type bar -DataSet $dsb3 -title "Bar Chart Example" -Labels $Labels -CanvasID $BarCanvasID

 
            
            }
        }
        

         
    }



$Path = ".\010.html"
$Html | Out-File -FilePath $Path -Encoding utf8
Start $Path 
