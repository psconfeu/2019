$p = 'P@ssw0rd'
[Net.ServicePointManager]::SecurityProtocol = 'Tls12'
$a,$b = (Get-FileHash -A 'SHA1' -I ([IO.MemoryStream]::
new([Text.Encoding]::UTF8.GetBytes($p)))).Hash -split '(?<=^.{5})'
(((irm "https://api.pwnedpasswords.com/range/$a" -UseB) -split
 '\r\n' -like "$b*") -split ':')[-1]
