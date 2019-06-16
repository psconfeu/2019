<#
    This example uses download information from a specific meetup group using MeetupPS.
    The data gathered using Meetup PS will be displayed in a Chart using PSHTML New-PSHTMLChart
#>

# Connect against Meetup.com API
import-module PSHTML -Force
Import-Module MeetupPS

$MeetupGroupName = 'FrenchPSUG'
#$MeetupGroupName = 'Research-Triangle-PowerShell-Users-Group'
#$MeetupGroupName = 'PowerShell-Usergroup-Hannover'

#region access
$Key = "1tuvvavlcf38a2f5r4skeorjed" #Set your Meetup key
$Secret = "f03pp1t8rnk0ub52fdsa9fmpk0" # Your Meetup Secret
#Set-MeetupConfiguration -ClientID $Key -Secret $Secret
#endregion

$CanvasID = "canvasAttendance"
$HTMLPageMeetup = html { 
    head {
        title 'Meetup information'

        Write-PSHTMLAsset -Name Jquery
        Write-PSHTMLAsset -Name BootStrap -Type Style
        Write-PSHTMLAsset -Name BootStrap -Type Script
        Write-PSHTMLAsset -Name Chartjs

    }

     $PSHTMLlink = a {"PSHTML"} -href "https://github.com/Stephanevg/PSHTML"  
     $PSHTMLLove = h6 "Generated with &#x2764 using $($PSHTMLlink)" -Class "text-center"


    body {
 
        div -class "Container" -Content {
            div -class "jumbotron" -content {
                h1 {
                    "Meetup information from $($MeetupGroupName)"
                } -class 'text-center'

                p {
                   "The following chart has been generated using PSHTML Chart.js and MeetupPS"
                } -Class "text-center lead" 
            }#end jumbotron
            
           div -Content {

               canvas -Height 600 -Width 800 -Id $CanvasID {
    
            } -Style 'display:inline'

              
            $PSHTMLLove
            $Data = Get-MeetupEvent -GroupName $MeetupGroupName -Status past | Sort 'local_date' | select Local_date,yes_rsvp_count,Name,Description
            
            $DataSetMeetup = New-PSHTMLChartBarDataSet -Data $Data.'yes_rsvp_count' -label 'Num Attendees' -backgroundColor 'Blue'
            
            $MeetupLabels = $data.'local_date'
            $newSort = $Data | sort Local_date -Descending
            
                
            div -Class "display:inline"{
                ConvertTo-PSHTMLTable -Object $newSort -Properties "Local_Date","yes_rsvp_count","name" -TableClass 'table table-striped table-bordered table-hover'
            }
                   
           } -class 'text-center'
       }

        script -content {

            $Data = Get-MeetupEvent -GroupName $MeetupGroupName -Status past | Sort 'local_date' | select Local_date,yes_rsvp_count,Name,Description
            $DataSetMeetup = New-PSHTMLChartBarDataSet -Data $Data.'yes_rsvp_count' -label 'Num Attendees' -backgroundColor 'Blue'
            $MeetupLabels = $data.'local_date'

            New-PSHTMLChart -Type bar -DataSet $DataSetMeetup -Title "$($MeetupGroupName) meetup Statistics over time" -Labels $MeetupLabels -canvasID $CanvasID

        }
    #region scripts
     #script -src "https://code.jquery.com/jquery-3.3.1.slim.min.js" -integrity "sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" -crossorigin "anonymous"
     #script -src "https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" -integrity "sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" -crossorigin 'anonymous'
     #script -src "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" -integrity "sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" -crossorigin 'anonymous'
    #endregion

    }
    Footer {
        $PSHTMLLove
    }
}

$OutPath = ".\013_frpsug_meetup.html"
$HTMLPageMeetup | out-file -FilePath $OutPath -Encoding utf8
start $outpath