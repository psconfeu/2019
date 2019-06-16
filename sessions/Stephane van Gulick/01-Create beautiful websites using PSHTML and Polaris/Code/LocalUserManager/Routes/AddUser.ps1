
New-PolarisPostRoute -Path '/adduser' -Force -Scriptblock {

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

   try{

        $SecurePassword = convertto-securestring -String $obj.Password -AsPlainText -Force
        $NewUserObject = New-LocalUser -Name $Obj.UserName -Password $SecurePassword -Description $obj.Description -ErrorAction stop
        $AdminGroup = Get-LocalGroup -Name "Administrators" -ErrorAction Stop
        Add-LocalGroupMember -Group $AdminGroup -Member $NewUserObject -ErrorAction Stop
        $Message = "Successfully created local admin user: $($obj.UserName)"
        $messageClasses = "alert alert-success"
   }Catch{
       $Message = $_
       $messageClasses = "alert alert-danger"
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

   $Response.Send($Html)
   

}    

