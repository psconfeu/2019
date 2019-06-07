Get-UDDashBoard | Stop-UDDashboard
<#
 
.DESCRIPTION
 Basic server information built on Universal Dashboard.
 
#> 
Start-UdDashboard -Content {
    $logo = New-UDImage -Path "$PSScriptRoot\optiver-dark.jpg" -Height 50 -Width 180
    New-UdDashboard -Title "Server Performance Dashboard" -Color '#FF050F7F' -NavBarLogo $logo -Content {
        New-UdRow {
            New-UdColumn -Size 6 -Content {
                New-UdRow {
                    New-UdColumn -Size 12 -Content {
                        New-UdTable -Title "Server Information" -Headers @(" ", " ") -Endpoint {
                            $uptime = (Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
                        
                            @{
                                'Computer Name' = $env:COMPUTERNAME
                                'Operating System' = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
                                'Total Disk Space (C:)' = [math]::Round(((Get-Volume -DriveLetter C).Size /1gb), 2)
                                'Free Disk Space (C:)' = [math]::Round(((Get-Volume -DriveLetter C).SizeRemaining /1gb), 2)
                                'Uptime' = '{0} Days {1} Hours {2} Minutes' -f $uptime.Days, $uptime.Hours, $uptime.Minutes
                            }.GetEnumerator() | Out-UDTableData -Property @("Name", "Value")
                        }
                    }
                }
                New-UdRow {
                    New-UDSelect -Label 'Select NetworkAdapter' -Id NetworkAdapter -Option {
                        foreach($netAdapter in (Get-NetAdapterStatistics)) {
                            New-UDSelectOption -Name $netAdapter.Name -Value $netAdapter.InterfaceDescription
                        }
                    } -OnChange {
                        $Session:networkAdapterDescription = $EventData
                        Sync-UDElement -Id NetworkIoIn
                        Sync-UDElement -Id NetworkIoOut
                    }

                    New-UdColumn -Size 6 -Content {
                        New-UDRow -AutoRefresh -RefreshInterval 1 -Id NetworkIoIn -Endpoint {
                            $netAdapterDescription = if(-not($session:networkAdapterDescription)) {
                                Get-NetAdapterStatistics | Select-Object -Last 1 -ExpandProperty InterfaceDescription
                            } else {
                                $session:networkAdapterDescription
                            }

                            $netAdapterCounterName = '\Network Adapter({0})\Bytes Received/sec' -f ($netAdapterDescription).Replace('(','[').Replace(')',']')

                            try {
                                $max = ((Get-NetAdapter | Where-Object {$_.InterfaceDescription -eq $netAdapterDescription}).ReceiveLinkSpeed /1kb) /8
                                $value = (Get-Counter $netAdapterCounterName -ErrorAction SilentlyContinue | 
                                    Select-Object -ExpandProperty CounterSamples | 
                                    Select-Object -ExpandProperty CookedValue) /1kb

                                New-UDHeading -Text 'Network kB Received/sec' -Size 5
                                New-UDKnob -Value $value -Maximum $max -BackgroundColor '#050F7F' -ForegroundColor "#EA5F40" -Title 'Network kB Received/sec'
                            } catch {
                                New-UDKnob -Value 0 -Maximum $max -BackgroundColor '#050F7F' -ForegroundColor "#EA5F40" -Title 'Network kB Received/sec'
                            }
                        }
                    }
                    New-UdColumn -Size 6 -Content {
                        New-UDRow -AutoRefresh -RefreshInterval 1 -Id NetworkIoOut -Endpoint {
                            $netAdapterDescription = if(-not($session:networkAdapterDescription)) {
                                Get-NetAdapterStatistics | Select-Object -Last 1 -ExpandProperty InterfaceDescription
                            } else {
                                $session:networkAdapterDescription
                            }

                            $netAdapterCounterName = '\Network Adapter({0})\Bytes Sent/sec' -f ($netAdapterDescription).Replace('(','[').Replace(')',']')
                            
                            try {
                                $max = ((Get-NetAdapter | Where-Object {$_.InterfaceDescription -eq $netAdapterDescription}).TransmitLinkSpeed /1kb) /8
                                $value = (Get-Counter $netAdapterCounterName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty CounterSamples | 
                                    Select-Object -ExpandProperty CookedValue) /1kb

                                New-UDHeading -Text 'Network kB Sent/sec' -Size 5
                                New-UDKnob -Value $value -Maximum $max -BackgroundColor '#050F7F' -ForegroundColor "#EA5F40" -Title 'Network kB Sent/sec'
                            } catch {
                                New-UDKnob -Value 0 -Maximum $max -BackgroundColor '#050F7F' -ForegroundColor "#EA5F40" -Title 'Network kB Sent/sec'
                            }
                        }
                    }
                }
                New-UdRow {
                    New-UdColumn -Size 12 -Content {
                        $defaultEventLogName = 'Application'

                        New-UDSelect -Label EventLog -Option {
                            foreach($log in @('Application', 'System')) {
                                New-UDSelectOption -Name $log -Value $log
                            }
                        } -OnChange {
                            $Session:eventLogName = $EventData
                            Sync-UDElement -Id EventLogGrid
                        }

                        $displayProperties = @("TimeGenerated", "EntryType", "Message", "Source", "EventID", "Full")
                        New-UdGrid -Headers $displayProperties -Properties $displayProperties -AutoRefresh -RefreshInterval 60 -DefaultSortColumn TimeGenerated -DefaultSortDescending -Id EventLogGrid -Endpoint {
                            $eventLog = if($Session:eventLogName) {
                                $Session:eventLogName
                            } else {
                                $defaultEventLogName
                            }
                            $data = foreach($event in (Get-EventLog -LogName $eventLog -Newest 100)) {
                                $messageMaxLength50 = try {
                                    $event.Message.Remove(50)
                                } catch {
                                    $event.Message
                                }

                                [pscustomobject]@{
                                    TimeGenerated = '{0} {1}' -f $event.TimeGenerated.ToShortDateString(), $event.TimeGenerated.ToShortTimeString()
                                    EntryType = $event.EntryType.ToString()
                                    Message = $messageMaxLength50
                                    Source = $event.Source
                                    EventID = $event.EventID
                                    Full = New-UDElement -Tag 'a' -Attributes @{ 
                                        onClick = { 
                                            Show-UDModal -Content { 
                                                $event.psobject.Properties | Out-UDTableData -Property @('Name', 'Value')
                                            } 
                                        }
                                    } -Content { 'View' }
                                }
                            }

                            $data | Out-UDGridData
                        }
                    }
                }
            }
            New-UdColumn -Size 6 -Content {
                New-UdRow {
                    New-UdColumn -Size 6 -Content {
                        New-UdMonitor -Title "CPU (% processor time)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80FF6B63' -ChartBorderColor '#FFFF6B63' -Endpoint {
                            try {
                                Get-Counter '\Processor(_Total)\% Processor Time' -ErrorAction SilentlyContinue | 
                                Select-Object -ExpandProperty CounterSamples | 
                                Select-Object -ExpandProperty CookedValue | 
                                Out-UDMonitorData
                            }
                            catch {
                                0 | Out-UDMonitorData
                            }
                        }
                    }
                    New-UdColumn -Size 6 -Content {
                        New-UdMonitor -Title "Memory (% in use)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#8028E842' -ChartBorderColor '#FF28E842' -Endpoint {
                            try {
                                Get-Counter '\memory\% committed bytes in use' -ErrorAction SilentlyContinue | 
                                Select-Object -ExpandProperty CounterSamples | 
                                Select-Object -ExpandProperty CookedValue | 
                                Out-UDMonitorData
                            }
                            catch {
                                0 | Out-UDMonitorData
                            }
                        }
                    }
                }
                New-UdRow {
                    New-UdColumn -Size 6 -Content {
                        New-UdMonitor -Title "Physical Disk (Disk Read Bytes/sec)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80E8611D' -ChartBorderColor '#FFE8611D' -Endpoint {
                            try {
                                Get-Counter '\PhysicalDisk(_total)\Disk Read Bytes/sec' -ErrorAction SilentlyContinue | 
                                Select-Object -ExpandProperty CounterSamples | 
                                Select-Object -ExpandProperty CookedValue | 
                                Out-UDMonitorData
                            }
                            catch {
                                0 | Out-UDMonitorData
                            }
                        }
                    }
                    New-UdColumn -Size 6 -Content {
                        New-UdMonitor -Title "Physical Disk (Disk Write Bytes/sec)" -Type Line -DataPointHistory 20 -RefreshInterval 5 -ChartBackgroundColor '#80E8611D' -ChartBorderColor '#FFE8611D' -Endpoint {
                            try {
                                Get-Counter '\PhysicalDisk(_total)\Disk Write Bytes/sec' -ErrorAction SilentlyContinue | 
                                Select-Object -ExpandProperty CounterSamples | 
                                Select-Object -ExpandProperty CookedValue | 
                                Out-UDMonitorData
                            }
                            catch {
                                0 | Out-UDMonitorData
                            }
                        }
                    }
                }
                New-UdRow {
                    New-UdColumn -Size 12 {
                        New-UdGrid -Title "Processes" -Headers @("Name", "ID", "Working Set", "CPU") -Properties @("Name", "Id", "WorkingSet", "CPU") -AutoRefresh -RefreshInterval 60 -Endpoint {
                            Get-Process | Out-UDGridData
                        }
                    }
                }
            }
        }
    } -EndpointInitialization (New-UDEndpointInitialization -Module "UniversalDashboard.Knob") 
} -Port 10000