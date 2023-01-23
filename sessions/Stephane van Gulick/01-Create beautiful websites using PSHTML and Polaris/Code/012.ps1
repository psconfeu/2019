<#
    The following example called 'tribute to Snover' grasps information for the 'shellfather' from around the internet, and generates a html page with the information.
    This example ilustrates how we can leverage the power of powershell, to fetch and filter information on various websites (using invoke-webrequest)

    Display it using PSHTML, and add a PSHTML Assets (Bootstrap and Jquery) for the styling part.

    
#>

import-module pshtml

$Snover = Html {
div -Class "Container"{
    head -content {
        Title "Tribute to snover"
        Link -rel stylesheet -href 'https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css'

    }
    Body{
        
            h1 "Tribute to Jeffrey Snover" -Class "text-center"

        div -Class "Photo" {

            img -src "https://pbs.twimg.com/profile_images/1039650689620688896/ZZgN5c9Y_400x400.jpg" -Class "rounded-circle mx-auto d-block" -alt "Jeffrey Snover photo" -height "400" -width "400" 
        }

            div -id "Bio" {
            $WikiRootSite = "https://en.wikipedia.org"
            $Source = a {"Wikipedia"} -href $WikiRootSite
            h2 "Biography"
            h4 "Source --> $Source"

            #Gathering the biography information from Wikipedia
            $wiki = Invoke-WebRequest -Uri ($WikiRootSite + "/wiki/Jeffrey_Snover")
            $Output = $Wiki.ParsedHtml.getElementById("mw-content-text").children | Where-Object -FilterScript {$_.ClassName -eq 'mw-parser-output'}
            $Bio = $Output.Children | Where-Object -FilterScript {$_.TagName -eq 'p'} | Select-Object -Property Tagname,InnerHtml

            foreach ($p in $bio){
                if($p.InnerHtml -ne $null){
                    #The url are relative on Wiki website. Correcting it here so that the Links are still working
                    $Corrected = $p.innerHTML.Replace("/wiki/","$WikiRootSite/wiki/")
                    p{

                        $Corrected
                    }
                }


            }

        }#End Accomplishements
        Div -id "Snoverisms" {
            $SnoverismsSite = "http://snoverisms.com/"

            h2 "Snoverisms"
            h4 "Source --> $SnoverismsSite"

            $Page = Invoke-WebRequest -Uri $SnoverismsSite
            $Snoverisms = $Page.ParsedHtml.getElementsByTagName("p") | Where-Object -FilterScript {$_.ClassName -ne "site-description"} | Select-Object -Property innerhtml
            $Snoverisms += (Invoke-WebRequest -uri "http://snoverisms.com/page/2/").ParsedHtml.getElementsByTagName("p") | Where-Object -FilterScript {$_.ClassName -ne "site-description"} | Select-Object -Property innerhtml

            ul -id "snoverism-list" -Content {
                Foreach ($snov in $Snoverisms){

                    li -Class "snoverism" -content {
                        $snov.innerHTML
                    }
                }

            }#end of ul
        }
        }
        Write-PSHTMLAsset -Name Jquery
        Write-PSHTMLAsset -Name BootStrap -Type Script
    }
    Footer{
        $PSHTMLlink = a {"PSHTML"} -href "https://github.com/Stephanevg/PSHTML"
        
        h6 "Generated with &#x2764 using $($PSHTMLlink)" -Class "text-center"
    }

}

$Snover > "012.html"
start "012.html"