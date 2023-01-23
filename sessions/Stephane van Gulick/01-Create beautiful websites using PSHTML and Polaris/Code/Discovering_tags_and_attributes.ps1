<#
    Explanation on how to extend the PSHTML tag possibilities using -Attributes
    
    For the ones that need more then the currently existing available parameters in PSHTML, I explained here how to find additional HTML attributes using a few simple 
    Google searches, and then combining that with the use of -Attributes parameter
#>

$Form = Form -action 'otherpage.html' -method post -Content {
    
    
    input -name 'email' -type text -Attributes @{pattern='^.*@.*\..*'}
    
    
    input -name 'btn_submit' -type submit
} -enctype application/x-www-form-urlencoded

$Form > .\input.html
start .\input.html