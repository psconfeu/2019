# Basic Page

$html = html {

    head{

        title "woop title"
        link "css/normalize.css" "stylesheet"
    }

    body{

        Header {
            h1 "This is h1 Title in header"
            div {
                p {
                    "This is simply a paragraph in a div."
                }
            }
        }

            div  {
                p{
                    "Checkout these different titles!"
                }
                h1 "This is h1"
                h2 "This is h2"
                h3 "This is h3"
                h4 "This is h4"
                h5 "This is h5"
                h6 "This is h6"
                strong "plop";"Woop"
            }
    }

}

#Saving content to a file

$Path = ".\002.html"
$Html | Out-File -FilePath $Path -Encoding utf8
Start $Path 