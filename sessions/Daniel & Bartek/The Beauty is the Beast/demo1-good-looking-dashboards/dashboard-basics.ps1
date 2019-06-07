Get-UDDashboard | Stop-UDDashboard

Start-UDDashboard -Content {
    New-UDDashboard -Title 'Dashboard Basics' -Content {
        New-UDRow {
            foreach ($columnNumber in @(1..12)) {
                New-UDColumn -Size 1 -Content {
                    New-UDCard -Text $columnNumber -TextSize Medium #-BackgroundColor ([System.ConsoleColor]::GetNames([System.ConsoleColor]) | Get-Random)
                }
            }
        }
        <#
        New-UDRow {
            foreach ($columnNumber in (1..6)) {
                New-UDColumn -Size 2 -Content {
                    New-UDCard -Text $columnNumber -TextSize Medium #-BackgroundColor ([System.ConsoleColor]::GetNames([System.ConsoleColor]) | Get-Random)
                }
            }
        }
        #>
        <#
        New-UDRow {
            New-UDColumn -Size 6 -Content {
                foreach ($columnNumber in @(1..12)) {
                    New-UDColumn -Size 1 -Content {
                        New-UDCard -Text $columnNumber -TextSize Medium #-BackgroundColor ([System.ConsoleColor]::GetNames([System.ConsoleColor]) | Get-Random)
                    }
                }
            }
        }
        #>
        <#
        New-UDRow {
            New-UDColumn -Size 4 -MediumOffset 2 -Content {
                New-UDCard -Text 'Size 4 Column' -TextSize Medium
            }
        }
        #>
    }
} -Port 10000