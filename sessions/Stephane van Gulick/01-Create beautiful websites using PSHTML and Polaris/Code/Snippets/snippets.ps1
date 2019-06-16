<#
    PSHTML comes with Snippets for VSCode.
    Install them using:

     Install-PSHTMLVSCodeSnippets

     Then, to use them, type PSHTML followed by CTRL + Space
#>

Import-Module pshtml

doctype { 
html -Attributes @{lang="en"} {
    head {
        meta -charset 'UTF-8'
        meta -name 'author' -content "stephane van Gulick"
        Title -Content "PsConfeu"
        Write-PSHTMLAsset -Name JQuery 
        Write-PSHTMLAsset -Name Bootstrap 
    }
    body {
     div -Class 'container' {

        p {
            "Salutations!"
        }

}
        footer {

        }
    }
} 
}