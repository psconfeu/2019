# 2019
Code, Materials and Slides for psconf.eu 2019

To view the psconf.eu 2019 agenda from PowerShell 1-5, run this:
irm http://powershell.love  | ConvertFrom-CSV | ogv -Title 'http://psconf.eu  2019 Sessions'
-or-
Invoke-RestMethod -Uri http://powershell.love  | ConvertFrom-CSV | Out-GridView -Title 'http://psconf.eu  2019 Sessions'

Since PowerShell 6 is missing Out-GridView, to save the agenda as a csv file, run this:
irm powershell.love | sc $home/desktop/psconfeu_2019_sessions.csv -en UTF8
-or-
Invoke-RestMethod -Uri powershell.love | Set-Content -Path $home/desktop/psconfeu_2019_sessions.csv -Encoding UTF8

