# Console.... Just start a script, or run in-line:
Start-UDDashboard -Port 1234 -Name JustTest
Start-Process http://localhost:1234
Get-UDDashboard -Name JustTest | Stop-UDDashboard

$udCert = Get-ChildItem Cert:\LocalMachine\My -DnsName ud.monad.net
Select-String -LiteralPath C:\Windows\system32\drivers\etc\hosts -Pattern ^\d.*ud

Start-UDDashboard -Port 1234 -Name WithHttps -Certificate $udCert 
Start-Process https://ud.monad.net:1234
Get-UDDashboard -Name WithHttps | Stop-UDDashboard