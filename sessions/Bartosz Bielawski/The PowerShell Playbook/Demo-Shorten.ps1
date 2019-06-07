#region DPS

throw "Hey, Dory! Forgot to use F8?"

#endregion

 Challenge
$p = 'P@ssw0rd'

#region initial...
$a,$b = (Get-FileHash -A 'SHA1' -I ([IO.MemoryStream]::new([Text.Encoding]::UTF8.GetBytes($p)))).Hash -split '(?<=^.{5})';(((irm "https://api.pwnedpasswords.com/range/$a" -UseB) -split '\r\n' -like "$b*") -split ':')[-1]
#endregion

#region Get- is optional...
Get-FileHash -A 'SHA1' -Path $psISE.CurrentFile.FullPath
FileHash -A 'SHA1' -Path $psISE.CurrentFile.FullPath

#endregion

#region magic of ForEach
[Text.Encoding]::UTF8.GetBytes($p)
[Text.Encoding]::UTF8|% G*es $p

#endregion

#region Regex
(((irm "https://api.pwnedpasswords.com/range/$a" -UseB) -split '\r\n' -like "$b*") -split ':')[-1]
[regex]"(?ms).*^$b.(\d+).*"|% Re* (irm "https://api.pwnedpasswords.com/range/$a" -UseB) `$1
#endregion

#region Invoke-Expression maybe...?
'[regex]"(?ms).*^{1}.(\d+).*"|% Re* (irm "https://api.pwnedpasswords.com/range/{0}" -UseB) `$1'-f((FileHash -A SHA1 -I ([IO.MemoryStream]::
new(([Text.Encoding]::UTF8|% G*es $p)))).Hash -split '(?<=^.{5})')|iex
#endregion

#region Space? But... why?
$c, $d = 1, 2
$c,$d=1,2

FileHash -A 'SHA1' $psISE.CurrentFile.FullPath
FileHash -A SHA1 $psISE.CurrentFile.FullPath

'FA2AE2B6D27CB46F566CAC0022EC24CE12E' -split '(?<=^.{5})'
'FA2AE2B6D27CB46F566CAC0022EC24CE12E'-split'(?<=^.{5})'

$null = irm "https://api.pwnedpasswords.com/range/$a"
$null = irm https://api.pwnedpasswords.com/range/$a
#endregion

#region final result....
$a,$b=(FileHash -A SHA1 -I ([IO.MemoryStream]::new(([Text.Encoding]::UTF8|% G*es $p)))).Hash-split'(?<=^.{5})';[regex]"(?ms).*^$b.(\d+).*"|% Re*(irm https://api.pwnedpasswords.com/range/$a -UseB)`$1

# OR
'[regex]"(?ms).*^{1}.(\d+).*"|% Re* (irm https://api.pwnedpasswords.com/range/{0} -UseB)`$1'-f((FileHash -A SHA1 -I ([IO.MemoryStream]::new(([Text.Encoding]::UTF8|% G*es $p)))).Hash-split'(?<=^.{5})')|iex


#endregion

#region but... outside the box?
FileHash -A SHA1 -I ([IO.MemoryStream]::new(([Text.Encoding]::UTF8|% G*es $p)))
$p|sc -N a;filehash a -a SHA1
$a,$b=$($p|sc -N a;filehash a -a SHA1).Hash-split'(?<=^.{5})';[regex]"(?ms).*^$b.(\d+).*"|% Re*(irm https://api.pwnedpasswords.com/range/$a -UseB)`$1
    
'[regex]"(?ms).*^{1}.(\d+).*"|% Re* (irm https://api.pwnedpasswords.com/range/{0} -UseB)`$1'-f($($p|sc -N a;filehash a -a SHA1).Hash-split'(?<=^.{5})')|iex


#endregion