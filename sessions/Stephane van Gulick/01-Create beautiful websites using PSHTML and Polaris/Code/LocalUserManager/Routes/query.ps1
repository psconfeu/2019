
New-PolarisPostRoute -Path "/query" -Scriptblock {
    $Reponse.Send($Request.BodyString)
} -Force