throw 'Dont run with F5'

# Start with Presentation
Invoke-Item 'C:\Repos\Private-GIT\psconf\Palantir\WEF_MateuszCzerniawski_psconfeu19.pptx'

#GitHub repo
Start-Process msedge.exe 'https://github.com/mczerniawski/WEFTools'

# Prepare GPO as a starting point for GPO policies
Start-Process msedge.exe 'https://github.com/mczerniawski/WEFTools/blob/master/docs/GPO_prepare.md'

# Prepare Azure Log Analytics workspace
Start-Process msedge.exe 'https://github.com/mczerniawski/WEFTools/blob/master/docs/Deploy-AzureLog-Workspace.md'

# Deploy Windows Event Forwarding in automated way
Start-Process msedge.exe 'https://github.com/mczerniawski/WEFTools/blob/master/docs/Deploy.md'

# Deploy Tools on WEC server 
Start-Process msedge.exe 'https://github.com/mczerniawski/WEFTools/blob/master/docs/DeployWEF.md'

#Main entrance
code 'C:\Repos\Private-GIT\WEFTools\WEFTools\Public\Get-EventFromWEC.ps1'
code 'C:\Repos\Private-GIT\WEFTools\WEFTools\Public\Write\Write-EventToLogAnalytics.ps1'

#Deploy on testlab - Hyper-V
    # 1. Show basic configuration  - domain and nothing on WEC
    # 2. Deploy WEF and WEFTools

#Switch to RemoteLab
    # Show the Lab
    # Show WEC Events, schedule task and Log Folder
    # Run demorun.ps1
    # Show definition
code 'C:\Repos\Private-GIT\WEFTools\WEFTools\Configuration\Definitions\OSCrash.json'
code  'C:\Repos\Private-GIT\WEFTools\WEFTools\Configuration\Definitions\OSStartupShutdownCrash.json'

#Demo1 if remote connectivity failed
Invoke-Item 'C:\Repos\Private-GIT\psconf\Palantir\WEF_Demo1.mp4'

# Azure Log Analytics and basic KQL
code 'C:\Repos\Private-GIT\psconf\Palantir\ALQuery.md'
Start-Process msedge.exe 'https://portal.azure.com/#@arcon.net.pl/resource/subscriptions/5c5be126-0e1c-4fc6-b68c-d14fc89c3f6d/resourcegroups/rg-loganalytics/providers/microsoft.operationalinsights/workspaces/la-psconf/logs'

#Azure Monitor sample
Start-Process msedge.exe 'https://portal.azure.com/#blade/Microsoft_Azure_Monitoring/UpdateVNextAlertRuleBlade/ruleInputs/%7B%22alertId%22%3A%22subscriptions%2F5c5be126-0e1c-4fc6-b68c-d14fc89c3f6d%2FresourceGroups%2Frg-loganalytics%2Fproviders%2FMicrosoft.OperationalInsights%2Fworkspaces%2Fla-psconf%2FActions%2Fd724144f-8897-40c1-a7c5-1a154baef62e%7C2dd95c25-f6c6-4b74-8157-fd18a3789a92%7C95f7c931-c3ad-411b-b792-f4b23b4a42dc%22%7D'

## and Teams notification:
Start-Process msedge.exe 'https://teams.microsoft.com/_#/conversations/WEC%20Alerts?threadId=19:afe6fc99f48245ba8eb4e18680b5985c@thread.skype&ctx=channel'

# Azure Dashboard sample
Start-Process msedge.exe 'https://portal.azure.com/#@arcon.net.pl/dashboard/private/82caa346-4355-4ea7-8181-52af152103cb'

#Cost and billing
Start-Process msedge.exe 'https://portal.azure.com/#@arcon.net.pl/resource/subscriptions/5c5be126-0e1c-4fc6-b68c-d14fc89c3f6d/overview'

#Demo2 if Azure connectivity failed
Invoke-Item 'C:\Repos\Private-GIT\psconf\Palantir\WEF_Demo2.mp4'

# PowerBI Dashboard and how to replace subscriptionID
Invoke-Item 'C:\Repos\Private-GIT\psconf\Palantir\WEFDashboard.pbix'


#Back to Slides
Invoke-Item 'C:\Repos\Private-GIT\psconf\Palantir\WEF_MateuszCzerniawski_psconfeu19.pptx'