$p = 'P@ssw0rd'
$p|Out-File -non 'p'
$a,$b=(filehash -a SHA1 ./p).hash-split '(?<=^.{5})'
(((irm "https://api.pwnedpasswords.com/range/$a")-split '\r\n'-like "$b*")-split ':')[-1]
