# Using bootstrap
import-module pshtml -force
$html = html {
    head {
        #Adding references
        Write-PSHTMLAsset
    }
    Body {
        div -Class 'container' -content {

            div -Class "jumbotron" -Content {
                h1 "With bootstrap"
            
                p {
                    "random message"
                }
            }

            p "This is a paragraph"

            div -Class "alert alert-success" -Content {
                p "Another message"
            }
            
        } #end div container
        
    }     
}

$html | Out-File -FilePath ".\004.1.html" -Encoding utf8
start ".\004.1.html" 