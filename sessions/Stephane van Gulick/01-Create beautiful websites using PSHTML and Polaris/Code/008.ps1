<#
    PSHTML can create charts very easily as described in this example below.
    (This example will only work with an internet connection as it uses a CDN ( Line 27))
#>

$BarCanvasID = "barcanvas"
$HTML = html { 
    head {
        title 'Chart JS Demonstration'
        
    }
    body {
        
        h1 "PSHTML Graph"

        div {
            
           p {
               "This is a bar Chart"
           }
           canvas -Height 400px -Width 400px -Id $BarCanvasID {
    
           }

       }

        script -src "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.3/Chart.min.js" -type "text/javascript"

        script -content {


            $Data3 = @(4,1,6,12,17,25,18,17,22,30,35,44)
            $Labels = @("January","February","Mars","April","Mai","June","July","August","September","October","November","december")

            $dsb3 = New-PSHTMLChartBarDataSet -Data $data3 -label "2018" -BackgroundColor 'blue'

            New-PSHTMLChart -type bar -DataSet $dsb3 -title "Bar Chart Example" -Labels $Labels -CanvasID $BarCanvasID

 
            
        }

         
    }
}


$Path = ".\008.html"
$Html | Out-File -FilePath $Path -Encoding utf8
Start $Path 