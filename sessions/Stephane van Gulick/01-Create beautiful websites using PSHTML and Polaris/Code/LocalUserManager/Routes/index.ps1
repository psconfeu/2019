
New-PolarisGetRoute -Path "/index" -Scriptblock {
    import-module Microsoft.PowerShell.LocalAccounts
    $Response.SetContentType('text/html')
    
    $Group = Get-LocalGroup -Name "Administrators"
    $Users = Get-LocalGroupMember -Group $Group
    $PSHTMLlink = a {"PSHTML"} -href "https://github.com/Stephanevg/PSHTML"  
     $PSHTMLLove = h6 "Generated with &#x2764 using $($PSHTMLlink)" -Class "text-center"
    $HTML = html {
        head {
            

            #Bootstrap
            
            Link -href "\styles\bootstrap\bootstrap.min.css" -rel "stylesheet"
            script -src "\styles\bootstrap\bootstrap.min.js"
            script -src "\styles\bootstrap\JQuery\jquery-3.3.1.slim.min.js"
            
            script -src "styles/chartjs/Chart.bundle.min.js" -type "text/javascript"
            title 'Local User Manager'
        }
        body {

            div -Class "container" -Content {
            div -class 'jumbotron' -content {
                h1 -class 'display-4' -content "Local User management"
                hr -Class "my-4"
                p -Class "lead" -Content "Create and remove users from the local administrators group"
            }
            h6 -Class "text-center" -Content {"PSHTML &#x2764 Polaris"}
            
                $Group = Get-LocalGroup -Name "Administrators"
                $Users = Get-LocalGroupMember -Group $Group
    

                div -id "listmembers" -Content {
                    h3 "The Admin group $($Group.Name) contains $($Users.Count) users"
                    ConvertTo-PsHtmlTable -Object $Users -Properties "Name","SID" -TableClass "table table-striped table-bordered table-hover"
                }
    
    
                div -Id "add users" -content {
                    h3 {
                        "Add user:"
                    }
            
                    Form -action "/adduser" -method post -id "adduser" -Content {
                        
                            
                                Legend -Content "New Local Administrator user:"
                                "UserName"
                                br
                                input -type 'text' -name "UserName"
                                br
                                "Description"
                                br
                                input -type 'text' -name "Description"
                                br
                                "Password"
                                br
                                input -type 'password' -name "Password"
                                br
                            
                            input -type submit -Name 'Create' -Id "btn_Create"
                            br
                            #input -type hidden -name 'redirect' -value 'http://localhost:8080/index.html'
                        
                    } -enctype 'application/x-www-form-urlencoded' -target _self
            
            
                }
    
                #>
                
                
                div -id "removeuser" -Content {
    
                    h3 {
                        "Remove user:"
                    }
    
    
                    Form -action "/removeuser" -method post -id "removeuser" -Content {
                       
                        
            
                        SelectTag {
                            foreach($U in $Users){
                                option -value $($U.SID) -Content $($U.Name)
                            } 
                            
                            
                        } -Attributes @{name='UserSid'}
                        
                        input -type submit -Name 'Submit' -Id "btn_submit" -value "Remove"
                        br
                
            
                    } -enctype 'application/x-www-form-urlencoded' -target _self
                }
                #>
            }
           
            
            
        }
        footer -Content {
            $PSHTMLLove
        }
    }
    $Response.Send($HTML)
} -Force

