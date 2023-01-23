# Fun with the Filesystem Provider
Get-ChildItem -Path 'C:\demo' -filter '*.ps1'  
Get-ChildItem -Path 'C:\demo' -Include '*.ps1' # -Recurse

# Let's create a nonsense path name
. 'C:\demo\CreateRandomPathName.ps1'
[string] $a = Create-RandomPathName -BaseDir 'C:\scratch' -Length 210 
$a.length 

# Why not create more LONG path names
$minimum = 250
$maximum = 270

foreach ($n in $minimum..$maximum) {
    
    $testdir = Create-RandomPathName -Length $n -BaseDir 'c:\scratch\'
 
    try {
        New-Item -Path $testdir -ErrorAction Stop | Out-Null
    
        if (Get-Item -Path $testdir -ErrorAction Stop) {
             "Sucessfully created item with $n characters."
        }
        Start-Sleep -Milliseconds 600
        Remove-Item -Path $testdir -ErrorAction Stop
    }
    catch {
        "# FAILED to create item with $n characters!"
        return
    }
}
#endregion 