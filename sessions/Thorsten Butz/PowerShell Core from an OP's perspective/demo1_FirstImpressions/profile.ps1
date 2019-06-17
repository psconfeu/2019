<#
  .Synopsis
     Get-WinVer displays the OS build number as shown by winver.exe and optional additional build information.

  .DESCRIPTION
     Winver.exe displays a combined OS Build-number, consisting of the CurrentBuildNumber and the UBR (UpdateBuildRevision),
     which can be found in the Registry:
     HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\CurrentBuildNumber
     HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\UBR

     You can also query extended build information via BuildLabEx: 
     HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\BuildLabEx
          
     To decode the value of BuildLabEx you may want to watch Raymond Chen's explanation video (see RELATED LINKS).     

     To support remote registry access, the function utilizes the "[microsoft.win32.registrykey]" class 
     and the "-Computername" paramter. 

     You may choose from different formatting options such as
     - WinVer (default)
     - OSBuild (plain OSBuild string)
     - BuildLabEx (plain BuildLabEx value)
     - asObject  (combined information as Object)

  .LINK
    https://channel9.msdn.com/Blogs/One-Dev-Minute/Decoding-Windows-Build-Numbers
    https://github.com/thorstenbutz

  .NOTES
    Written by Thorsten Butz, Version 0.2

  .EXAMPLE
     Get-WinVer

  .EXAMPLE
     Get-WinVer -Format OSBuild 

  .EXAMPLE
     Get-WinVer -Format asObject -Computername pc1

  .EXAMPLE
    'pc1','pc2' | Get-WinVer -Format asObject | Format-Table
#>
function Get-WinVer
{
    [CmdletBinding()]      
    Param
    (
        [Parameter(ValueFromPipeline=$true)]
        [string]
        $Computername = $env:COMPUTERNAME, 
        [ValidateSet('Winver', 'OSBuild','BuildLabEx','asObject')] 
        [string]
        $Format = 'Winver'
    ) 

    Process {
      # [microsoft.win32.registrykey] does not support 'localhost'
      if ($computername -eq 'localhost') { $computername = $env:COMPUTERNAME }         
      
      # The network path might be unreachable
      try {
          $hive=[microsoft.win32.registrykey]::OpenRemoteBaseKey('LocalMachine',$computername)     
      }
      catch { 
          return
      }        
      
      $key = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion'

      $prop1 = 'BuildLabEx'
      $prop2 = 'CurrentBuildNumber' 
      $prop3 = 'ProductName' 
      $prop4 = 'ReleaseId'
      $prop5 = 'UBR'
      
      $value1 = ($hive.OpenSubKey($key)).getvalue($prop1)
      $value2 = ($hive.OpenSubKey($key)).getvalue($prop2)               
      $value3 = ($hive.OpenSubKey($key)).getvalue($prop3)
      $value4 = ($hive.OpenSubKey($key)).getvalue($prop4)
      $value5 = ($hive.OpenSubKey($key)).getvalue($prop5)
      
      $value1Arr = $value1.split('.')
      
      # Define/format the output
      
      switch ($format) {
          'Winver' {                                
              "$value3 Version $value4 (OS Build $value2.$value5)"
          }
          'OSBuild' { "$value2.$value5" }
          'BuildLabEx' { $value1 }
          'asObject' {
              [pscustomobject]@{
                  Computername = $computername
                  ProductName = $value3
                  ReleaseID = $value4
                  UBR = $value5 # UpdateBuildRevision 
                  MajorNumber = $value1Arr[0]
                  Update = $value1Arr[1]
                  Platform = $value1Arr[2]
                  Branch = $value1Arr[3]
                  Date = $value1Arr[4]    # Redmond local time as 24h clock
            }            
          }
      }    
    }
}

function prompt{ 
    $principal = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    if($principal.IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')){$color = 'red'} else {$color = 'darkgreen'}
    if ($PSVersionTable.PSEdition -eq 'Core') { $a  = '(' ; $b = ')' } else {  $a  = '[' ; $b = ']'} 
    $release = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\' 'ReleaseID').ReleaseID
    if ($IsLinux){'Linux'} else {[string] $os=Get-WinVer}
    Write-Host -b white -f Black -n "$($env:computername) | "
    Write-Host -b white -f $color -n  "$($Env:username) "
    Write-Host -b white -f Black "| PS $($PSVersionTable.PSVersion.tostring()) | $OS "
    "$pwd> "
} 
 
 

 Set-Location -Path 'c:\'
 Clear-Host
 if ($host.Name -eq 'ConsoleHost') {''}
