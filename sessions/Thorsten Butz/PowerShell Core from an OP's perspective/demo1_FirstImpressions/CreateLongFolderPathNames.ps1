param(
    [int] $minimum = 250,
    [int] $maximum = 270
)

#Create-RandomPath -Length 11 -BaseDir 'c:\scratch'

foreach ($n in $minimum..$maximum) {
    
    $testdir = Create-RandomPath -Length $n -BaseDir 'c:\scratch\'
 
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
        #$Error[0]
        return
    }
}
. C:\ps\CreateRandomPath.ps1
Create-RandomPath
New-Item -ItemType Directory -Path (Create-RandomPath -Length 266 -BaseDir 'c:\scratch')
New-Item -ItemType Directory -Path (Create-RandomPath -Length 267 -BaseDir 'c:\scratch')

New-Item -ItemType Directory -Path (Create-RandomPath -Length 266 -BaseDir 'R:')
Remove-PSDrive -Name 'R'
New-SmbShare -Name 'Scratch' -Path 'c:\scratch' -FullAccess 'Builtin\Administrators'
New-PSDrive -Name 'R' -PSProvider FileSystem -Root "\\$env:computername\scratch"
New-Item -ItemType Directory -Path (Create-RandomPath -Length 265 -BaseDir 'R:')
cmd /c dir r: 
net use r: "\\$env:computername\scratch"


Create-RandomPath -Length 266 -BaseDir 'c:' | clip
x:\gFxBzcuVlLPAeYiDYBuTOHTksTsKAGCpDfqnEghWRxbtbKxJsgGmXMUMtpeopeNyfWHYSxLCaqQJZAJaMwFbxykmepZGUOCrmqvZXAzrFREIEsCwOXgIbwhfcihGgHISeHyaVeXYfVCtKDUnFQUYBuabTBKQAZKxWGxjgdyVOBvUuuLbzGgvgXewYlnmyGwVBtthLyYkVZPqAypVBUsyokeepQWZkRSCckGVTRUuqvJoBgRJLSJqadeMdVuoeIbNJojROOi
