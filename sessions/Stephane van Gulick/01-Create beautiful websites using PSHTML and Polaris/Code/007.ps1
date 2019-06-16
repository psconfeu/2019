# Using Powershell logic (foreach, sorts etc..) and External modules (HyperV) to generate Reports with PSHTML (No Styling added here - yet)
Import-Module PSHTML

$html = html {
    head {
        title 'Adding logic'
        
    }
    body {
        h2 {
            "Local VM Report:"
        }
        import-module hyper-v
        $Vms = Get-VM | sort State
        
        h2 "All existing VM's"
        ConvertTo-PsHtmlTable -Object $Vms -Properties "Name","State"

        $AllRunningVMs = $Vms | ? {$_.State -eq 'Running'}
        h2 "Networking information from running machines"
        Foreach($vm in $AllRunningVMs){
            $net = $null
            h3 "$($vm.Name)"
            $net = Get-VMNetworkAdapter -VM $vm | select SwitchName,MacAddress,IpAddresses
            ConvertTo-PSHTMLTable -Object $net -Properties SwitchName,MacAddress,IpAddresses
        }
    }
}

$Path = ".\007.html"
$Html | Out-File -FilePath $Path -Encoding utf8
Start $Path 