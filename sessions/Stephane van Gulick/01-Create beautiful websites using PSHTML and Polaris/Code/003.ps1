Import-module PSHTML -Force




$Html = div {

    h1 "Important paramters available on all tags"

    p {
        "Paragraph with Custom Id"
    } -Id "TopParaGraph01"

    p {
        "Paragraph with Custom Class"
    } -Class "CustomClass01"
    
    p {
        "Paragraph with Custom Styling"
    } -Style "color:blue;font-size:46px;"
    
    P {
        "Paragraph with Custom Attributes"
    } -Attributes @{"CustomAttribute01"="CustomValue01";"CustomAttribute02"="CustomValue02"}
}


$Path = ".\003.html"
$Html | Out-File -FilePath $Path -Encoding utf8
Start $Path 
