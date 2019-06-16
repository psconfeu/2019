<#
    A more usefull example, displaying Meetup information using MeetupPS and PSHTML
    #For this Example to work, $Key and $Secret must be set first.
#>

import-module PSHTML 
Import-Module MeetupPS

$MeetupGroupName = 'FrenchPSUG'
$Key = ""
$Secret = ""
Set-MeetupConfiguration -ClientID $Key -Secret $Secret


$CanvasID = "canvasAttendance"
$Html = html { 
    head {
        title 'PSHTML Charts using Charts.js'
        
    }
    body {
        
        h1 "Generated using PSHTML"

        div {

           p {
               "The following chart has been generated using PSHTML Chart.js and MeetupPS"
           }
           canvas -Height 600 -Width 800 -Id $CanvasID {
    
           }
       }

         script -src "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.3/Chart.min.js" -type "text/javascript"


        script -content {

            
            $Data = Get-MeetupEvent -GroupName $MeetupGroupName -Status past | Sort 'local_date' | select Local_date,yes_rsvp_count

            $DataSetMeetup = New-PSHTMLChartBarDataSet -Data $data.'yes_rsvp_count' -label "Num Attendees" -backgroundColor blue

            $MeetupLabels = $data.'local_date'
            New-PSHTMLChart -type bar -DataSet $DataSetMeetup -title "FRPSUG meetup Statistics over time" -Labels $MeetupLabels -canvasID $CanvasID 
           
        }

         
    }
}

$Path = ".\009.html"
$Html | Out-File -FilePath $Path -Encoding utf8
Start $Path