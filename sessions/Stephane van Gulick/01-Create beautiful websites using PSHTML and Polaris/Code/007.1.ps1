Import-Module PSHTML

$html = html {
    head {
        Write-PSHTMLAsset
    }
    body {
        h1 "Adding Assets"
        p "Using only Write-PSHTMLAsset will add all existing assets"
    }
}

$Path = ".\007.1.html"
$Html | Out-File -FilePath $Path -Encoding utf8
Start $Path 