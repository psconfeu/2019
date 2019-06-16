Import-Module PSHTML

$html = html {
    head {
        title 'Export to table'
        
    }
    body {
        h1 "First 10 processes"
        $Process = Get-Process | select -First 10
        ConvertTo-PSHTMLTable -Object $Process -Properties "Name","Handles"
    }
}

$Path = ".\005.html"
$Html | Out-File -FilePath $Path -Encoding utf8
Start $Path 