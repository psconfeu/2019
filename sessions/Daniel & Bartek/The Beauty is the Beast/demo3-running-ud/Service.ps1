Set-Content -LiteralPath C:\Windows\Temp\dashboard.ps1 -Value 'Start-UDDashboard -Port 8080'
Publish-UDDashboard -DashboardFile C:\Windows\Temp\dashboard.ps1

Start-Service -Name UniversalDashboard 
Start-Process http://localhost:8080

New-Item -Path d:\udService -ItemType Directory

Get-Module -ListAvailable -Name UniversalDashboard |
    Split-Path | Get-ChildItem | Copy-Item -Recurse -Destination d:\udService

Get-ChildItem -LiteralPath $$
Set-Content -Path D:\udService\dashboard.ps1 -Value 'Start-UDDashboard -Port 9090'
New-Service -Name MyUD -BinaryPathName 'D:\udService\net472\UniversalDashboard.Server.exe --run-as-service'
Start-Service -Name MyUD

Start-Process http://localhost:9090
