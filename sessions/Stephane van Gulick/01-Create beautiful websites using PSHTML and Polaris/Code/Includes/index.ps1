#Import-module pshtml -force
$Code = html{
    Header{
        h1 "This is an example generated using PSHTML Templates"
    }
    Body{

        Write-PSHTMLInclude -Name body
        
    }
    Footer{
        #Include is an Alias for Write-PSHTMLInclude
        Include -Name footer 
    }
}

$code > .\includes.html
start .\includes.html