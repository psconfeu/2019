$params1 = @{
    Path =  'HKLM:\SOFTWARE\OpenSSH' 
    Name = 'DefaultShell' 
    ErrorAction = 'SilentlyContinue'
}

$params2 = @{
    Path = 'HKLM:\SOFTWARE\OpenSSH' 
    Name = 'DefaultShell'
    Value = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' 
    # Value = 'c:\Program Files\PowerShell\6\pwsh.exe'
    # Value = 'c:\pwsh\6\pwsh.exe'
    PropertyType = 'String' 
    Force = $true
}

# Query
(Get-ItemProperty @params1).DefaultShell

# Configure
New-ItemProperty @params2