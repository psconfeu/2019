
#Adding a custom Javascript library using Assets
New-Item -Path "C:\Program Files\WindowsPowerShell\Modules\PSHTML\0.7.11\Assets\PsConfEu2019\myJsCode.js" -Force 
#The JS file is empty here, but the example here is to illustrate that JAvascript / CSS frameworks (official or in house ones) can easily be added to a PSHTML webpage
import-module pshtml -force

$html = html {
    head {
        Write-PSHTMLAsset -Name PsConfEu2019
    }
    body {

    }
}

$Path = ".\007.2.html"
$Html | Out-File -FilePath $Path -Encoding utf8
Start $Path 