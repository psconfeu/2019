######################################################################
# Create a directory junction as a shortcut and avoid spaces in paths
######################################################################

# mklink /d c:\pwsh C:\Program Files\PowerShell
New-Item -ItemType 'Junction' -Path 'c:\pwsh' -Value 'C:\Program Files\PowerShell'