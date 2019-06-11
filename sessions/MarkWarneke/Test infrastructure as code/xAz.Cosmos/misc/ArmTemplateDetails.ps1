$json = ConvertFrom-Json (Get-Content "./xAz.Cosmos\static\azuredeploy.json" -Raw)

# Resources
$json.resources.type
$json.resources.name

$json.parameters | get-member -MemberType NoteProperty | select name

#region Create parameters object
$json.parameters | get-member -MemberType NoteProperty | % { [pscustomobject]@{ Name = $_.Name; Description = $json.parameters.($_.Name).metadata.description } } | clip
#endregion

#region Create parameters markdown
$json.parameters | get-member -MemberType NoteProperty | % { "|{0}|{1}|" -f $_.Name , $json.parameters.($_.Name).metadata.description  }
#endregion

#region Create azuredeploy.parameters.json
$json.parameters | get-member -MemberType NoteProperty | % { [pscustomobject]@{  $_.Name = @{ Value = $json.parameters.($_.Name).DefaultValue  } } } | ConvertTo-Json
#endregion