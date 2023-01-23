function Create-RandomPathName {
    [CmdletBinding()]
    param (
        [ValidateScript( { Test-Path -Path $_ })]
        [string] $BaseDir = (Get-Location).Path ,
        [int] $Length = 42
    )
    $basedir = $basedir.TrimEnd('\') + '\'
    if ( $basedir.Length -ge $Length ) { Write-Error -Message 'Length too short!'; return}
    [string] $somestring = 1..($length-$basedir.length) | % { [char] (Get-Random -InputObject (65..90 + 97..122)) }
    [string] $RandomPath = $basedir +  ($somestring -replace '\s')
    Write-Verbose -Message $RandomPath
    $RandomPath
}