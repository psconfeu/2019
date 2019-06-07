# Check .NET version
$dotNetRegistryPath = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'
($release = Get-ItemPropertyValue -Name Release -Path $dotNetRegistryPath -ErrorAction SilentlyContinue)
$release -ge 461814

# Install dotnet hosting package
.\dotnet-hosting-2.1.5-win.exe /install /passive /log C:\Windows\Temp\dotnetHosting.log

# Install IIS roles
Add-WindowsFeature -Name Web-WebSockets, Web-Windows-Auth

# Configure WebSite
Get-Module -ListAvailable -Name UniversalDashboard |
    Split-Path | Get-ChildItem | Copy-Item -Recurse -Destination C:\inetpub\wwwroot

Get-ChildItem -LiteralPath $$
Set-Content -Path C:\inetpub\wwwroot\dashboard.ps1 -Value 'Start-UDDashboard -Wait'

Start-Process http://localhost