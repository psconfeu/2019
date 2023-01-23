
Import-Module PSHTML
$html = p{
    h2 "Example with HTML table"
    
    table {
            caption "This is a table generated with PSHTML"
            thead {
                tr{
                    th "number1"
                    th "number2"
                    th "number3"
                }
            }
            tbody{
                tr{
                    td -Class "Warning" "Child 1.1"
                    td "Child 1.2"
                    td "Child 1.3"
                }
                tr{
                    td "Child 2.1"
                    td "Child 2.2"
                    td "Child 2.3"
                }
            }
            tfoot{
                tr{
                    td "Table footer"
                }
            }
        }
    }

    $Path = ".\004.html"
    $Html | Out-File -FilePath $Path -Encoding utf8
    Start $Path 