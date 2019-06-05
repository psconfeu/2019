throw 'Dont run with F5'


# Start with Presentation

Invoke-Item 'C:\Repos\Private-GIT\psconf\pChecks\PESTER_MateuszCzerniawski_psconfeu19.pptx'

#GitHub repo

Start-Process msedge.exe 'https://github.com/mczerniawski/pChecksAD'

# Basic module layout
code 'C:\Repos\Private-GIT\pChecksAD\pChecksAD\Index\AD.Checks.Index.json'
code 'C:\Repos\Private-GIT\pChecksAD\pChecksAD\Public\Invoke-pChecksAD.ps1'
code 'C:\Repos\Private-GIT\pChecksAD\pChecksAD\Private\Baseline\Get-pChecksBaselineConfigurationAD.ps1'

# Show BaseLineAD
code 'C:\Repos\Private-GIT\psconf\pChecks\BaselineAD\General\arcontest.pl.Configuration.json'
code 'C:\Repos\Private-GIT\psconf\pChecks\BaselineAD\Nodes\ARC-S1DC1.ARCONTEST.PL.Configuration.json'

# Deploy pChecksAD 
code 'C:\Repos\Private-GIT\psconf\pChecks\Deploy_pChecksAD.ps1'

# Prepare Azure Log Analytics workspace
code 'C:\Repos\Private-GIT\psconf\pChecks\Deploy_Workspace.ps1'

#Switch to RemoteLab
    # Show the Lab
    # Run create-ad-baseline.ps1
code 'C:\Repos\Private-GIT\psconf\pChecks\Sample_Run.ps1'

#Demo1 if remote connectivity failed
Invoke-Item 'C:\Repos\Private-GIT\psconf\pChecks\PESTER_Demo1.mp4'

# Azure Log Analytics and basic KQL
code 'C:\Repos\Private-GIT\psconf\pChecks\ALQuery.md'
Start-Process msedge.exe 'https://portal.azure.com/#@arcon.net.pl/resource/subscriptions/5c5be126-0e1c-4fc6-b68c-d14fc89c3f6d/resourcegroups/rg-loganalytics/providers/microsoft.operationalinsights/workspaces/la-psconf/logs'

#Azure Monitor sample
Start-Process msedge.exe 'https://portal.azure.com/#blade/Microsoft_Azure_Monitoring/UpdateVNextAlertRuleBlade/ruleInputs/%7B%22alertId%22%3A%22subscriptions%2F5c5be126-0e1c-4fc6-b68c-d14fc89c3f6d%2FresourceGroups%2Frg-loganalytics%2Fproviders%2FMicrosoft.OperationalInsights%2Fworkspaces%2Fla-psconf%2FActions%2Fd724144f-8897-40c1-a7c5-1a154baef62e%7C2dd95c25-f6c6-4b74-8157-fd18a3789a92%7C95f7c931-c3ad-411b-b792-f4b23b4a42dc%22%7D'

#Monitor Alerts
#Outlook and Teams

# Azure Dashboard sample
Start-Process msedge.exe 'https://portal.azure.com/#@arcon.net.pl/dashboard/private/82caa346-4355-4ea7-8181-52af152103cb'

#Cost and billing
Start-Process msedge.exe 'https://portal.azure.com/#@arcon.net.pl/resource/subscriptions/5c5be126-0e1c-4fc6-b68c-d14fc89c3f6d/overview'

#Demo2 if Azure connectivity failed
Invoke-Item 'C:\Repos\Private-GIT\psconf\pChecks\PESTER_Demo2.mp4'

# PowerBI Dashboard and how to replace subscriptionID
Invoke-Item 'C:\Repos\Private-GIT\psconf\pChecks\pChecksADDashboard.pbix'

#Back to Slides
Invoke-Item 'C:\Repos\Private-GIT\psconf\pChecks\PESTER_MateuszCzerniawski_psconfeu19.pptx'