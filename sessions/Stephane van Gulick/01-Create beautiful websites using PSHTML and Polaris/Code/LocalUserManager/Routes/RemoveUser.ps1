
New-PolarisPostRoute -Path "/removeuser" -Scriptblock {
    
    $Response.SetContentType('text/html')
    $Body = [System.Web.HttpUtility]::UrlDecode($Request.BodyString)
    $Body = [System.Web.HttpUtility]::UrlDecode($Request.BodyString)
    $Data = @{}
    $Body.split('&') | %{
        $part = $_.split('=')
        $Data.add($part[0], $part[1])
    }
    $Json = $Data | ConvertTo-Json
    $obj = $Json | ConvertFrom-Json

    $Group = Get-LocalGroup -Name 'Administrators'
    $LocalUser = Get-LocalUser -SID $Obj.UserSid
    If($LocalUser){
        Write-Verbose "Removing user $($LocalUser.FullName)"
        Try{

            Remove-LocalGroupMember -Group $Group -Member $LocalUser -ErrorAction Stop
            $Message = "Successfully removed user $($LocalUser.Name) with SID: $($Obj.UserSid)"
            $messageClasses = "alert alert-success"
        }Catch{
            $Message = $_
            $messageClasses = "alert alert-danger"
        }
    }else{
        $Message = "No user found with SID: $($Obj.UserSid)"
    }
    $html = html {
        head {
            meta -httpequiv refresh -content_tag "3;URL=http://localhost:8080/index"
            Link -href "\styles\bootstrap\bootstrap.min.css" -rel "stylesheet"
            script -src "\styles\bootstrap\bootstrap.min.js"
            script -src "\styles\bootstrap\JQuery\jquery-3.3.1.slim.min.js"
        }
        body{
            p {

                div -Class $messageClasses -content {
                    $Message
                    br
                    "redirecting in 3 seconds"
                }
                
            }
        }
    }
     $Response.Send($html)
     
} -force

