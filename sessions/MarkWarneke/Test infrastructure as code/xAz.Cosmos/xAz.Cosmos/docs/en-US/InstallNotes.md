# Installing xAz.Cosmos

You can install xAz.Cosmos
```PowerShell
Copy-Item xAz.Cosmos "$HOME\Documents\WindowsPowerShell\Modules\xAz.Cosmos"
Import-Module xAz.Cosmos
```


# Installing xAz.Cosmos

You can install xAz.Cosmos

```PowerShell
git clone  https:\\github.com/<MyRepo>/_git/<repo> --branch master --single-branch [<folder>]

Copy-Item xAz.Cosmos "$HOME\Documents\WindowsPowerShell\Modules\xAz.Cosmos"
Import-Module xAz.Cosmos
```

## Import

You can load xAz.Cosmos

``` PowerShell
Import-Module .\xAz.Cosmos\xAz.Cosmos.psd1
Get-Command -Module xAz.Cosmos
```

## Build and Test

Run individual tests from folder `.\xAz.Cosmos\Test`

```PowerShell
Invoke-Pester .\xAz.Cosmos\Test\
```

