param(
    [Parameter()]
    [int]
    $FactLength = -1
)

function Get-CatFact {
    param (
        
    )
    $url = "https://catfact.ninja/fact"

    if($FactLength -ge 0) { 
        $url += "?max_length=$FactLength"
    }

    $factResponse = Invoke-RestMethod $url
    $factResponse.fact
}

Write-Host "PSConfEU"

Get-CatFact

Write-Host "is awesome."
