Import-Module PSHTML

$html = html {
    head {
        title 'Export to table'
        link -href 'assets/home.css' -rel 'stylesheet'
    }
    body {
        h1 "My favorites Fruits"

        $Fruits = "Apple","Banana","Orange","Ananas"

        ul {

            foreach($fruit in $Fruits){
                li {
                    $fruit
                }
            }
        }

    }
}

$Path = ".\006.html"
$Html | Out-File -FilePath $Path -Encoding utf8
Start $Path 