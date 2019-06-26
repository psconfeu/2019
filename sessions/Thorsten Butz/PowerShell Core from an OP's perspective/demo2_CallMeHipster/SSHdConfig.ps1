# Adding SSH server in WS 2019 (d: = Features on demand DVD)
Get-WindowsCapability -Online -Source 'd:' -Name *ssh.server* | Add-WindowsCapability -Online -Source 'd:'

# Get/Set
Get-Service -Name ssh* | Format-Table -Property Starttype, Status, Name, Displayname
Get-Service -Name ssh* | Set-Service -StartupType Automatic -PassThru | Start-Service
Stop-Service -Name sshd, ssh-agent 
Start-Service -Name sshd, ssh-agent 

# Check FW rule
Get-NetFirewallRule -Name *ssh* | Format-Table -Property Name, Description, DisplayGroup, Enabled, Profile, Direction, Action

# Check connectivity
Test-NetConnection -ComputerName $env:computername -Port 22
ssh.exe $env:computername # CONSOLE APPLICATION! (Do not use in ISE!)

# Configure default shell via Registry
$params = @{
    Path = 'HKLM:\SOFTWARE\OpenSSH' 
    Name = 'DefaultShell'
    Value = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' 
    #Value = 'c:\Program Files\PowerShell\6\pwsh.exe'
    PropertyType = 'String' 
    Force = $true
}
New-ItemProperty @params

# sshd_config
Test-Path -path "$env:ProgramData\ssh\sshd_config"
psedit -filenames "$env:ProgramData\ssh\sshd_config" # Customize config file
Restart-Service -Name sshd

# Create link/junction to PowerShell to get rid of the space(s).
New-Item -ItemType Junction -Path 'c:\pwsh' -Value 'C:\Program Files\PowerShell'