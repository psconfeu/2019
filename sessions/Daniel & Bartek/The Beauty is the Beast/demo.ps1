$ScriptRoot = 'C:\Repositories\BeautyBeast' 

# Dashboards
ise $ScriptRoot\demo1-good-looking-dashboards\dashboard-basics.ps1
& $ScriptRoot\demo1-good-looking-dashboards\demo1-good-looking-interactive-dashboards.mp4

# Your first REST API in 5 minutes
& $ScriptRoot\demo2-rest-api-in-5-min\demo-rest-api-in-5-min.mp4

# Demo 3
& $ScriptRoot\demo3-running-ud\UD-as-service.mp4
& $ScriptRoot\demo3-running-ud\UD-in-IIS.mp4

# Demo 4 (Switch to domain controller)
ise $ScriptRoot\demo4-authorization-and-authentication\ud-authentication-dashboard.ps1

Copy-Item -Path C:\inetpub\wwwroot\ud-authentication.ps1 -Destination 'C:\inetpub\wwwroot\dashboard.ps1'
Restart-WebAppPool -Name DefaultAppPool

ise $ScriptRoot\demo4-authorization-and-authentication\ud-authorization.ps1

Copy-Item -Path C:\inetpub\wwwroot\ud-authorization.ps1 -Destination 'C:\inetpub\wwwroot\dashboard.ps1'
Restart-WebAppPool -Name DefaultAppPool

## & $ScriptRoot\demo4-authentication-and-authorization.mp4

# Demo 5
ise $ScriptRoot\demo5-whatIF\WhatTheIf.ps1
ise $ScriptRoot\demo5-whatIF\ud-dryRun.ps1

Copy-Item -Path C:\inetpub\wwwroot\ud-dryRun.ps1 -Destination 'C:\inetpub\wwwroot\dashboard.ps1'
Restart-WebAppPool -Name DefaultAppPool

Invoke-RestMethod -Method Get -Uri http://localhost/api/removeFile -UseDefaultCredentials

# Demo 6
ise $ScriptRoot\demo6-audit\AuditFunction.ps1
ise $ScriptRoot\demo6-audit\ud-with-audit.ps1

Copy-Item -Path C:\inetpub\wwwroot\ud-with-audit.ps1 -Destination 'C:\inetpub\wwwroot\dashboard.ps1'
Restart-WebAppPool -Name DefaultAppPool

Invoke-RestMethod -Method Get -Uri http://localhost/api/file/someName -UseDefaultCredentials
Get-WinEvent -ProviderName UDAudit -MaxEvents 1 | Format-List
Get-WinEvent -ProviderName UDAudit -MaxEvents 1 | ForEach-Object {
  $_.Message | ConvertFrom-Json
}

# Demo 7
ise $ScriptRoot\demo7-rest-api-for-monitoring\Send-BuildResult.ps1
ise $ScriptRoot\demo7-rest-api-for-monitoring\demo7-build-monitoring.ps1

# Demo 8
ise $ScriptRoot\demo8-rest-api-dns\ud-dns-api.ps1

Copy-Item -Path C:\inetpub\wwwroot\ud-dns-api.ps1 -Destination 'C:\inetpub\wwwroot\dashboard.ps1'
Restart-WebAppPool -Name DefaultAppPool

Invoke-RestMethod -Method Get -Uri http://localhost/api/dns/cnameListHost/linux.ud.psconf -UseDefaultCredentials

Invoke-RestMethod -Method Get -Uri http://localhost/api/dns/cnameSwap -Body @{
  Name = 'ud-test'
  Target = 'uddc.ud.psconf'
} -UseDefaultCredentials

Invoke-RestMethod -Method Post -Uri http://localhost/api/dns/cname -Body @{
  Name = 'ud-rocks'
  Target = 'uddc.ud.psconf'
} -UseDefaultCredentials

Invoke-RestMethod -Method Delete -Uri http://localhost/api/dns/cname -Body @{
  Name = 'ud-rocks'
  Target = 'uddc.ud.psconf'
} -UseDefaultCredentials

Resolve-DnsName -Name ud-rocks -Type CNAME

Invoke-RestMethod -Method Delete -Uri "http://localhost/api/dns/cname?Name=ud-rocks&Target=uddc.ud.psconf" -UseDefaultCredentials

Resolve-DnsName -Name ud-rocks -Type CNAME
