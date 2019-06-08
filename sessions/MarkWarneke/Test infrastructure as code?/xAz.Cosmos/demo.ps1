#region run pipeline locally
./xAz.Cosmos/psake.ps1 -TaskList UnitTest

break
#endregion

#region Validate Azure
./xAz.Cosmos/Test/Validation/New-Deployment.spec.ps1 -TestValueFiles ./setup/config.psconf.json

break
#endregion

#region module demo
Invoke-Pester ./xAz.Cosmos/Test/Module -Show Fails -PassThru
break
#endregion

#region Demo Code
import-module ./xAz.Cosmos/xAz.Cosmos.psd1

Get-xAzCosmosName -Environment S -Descriptor 'HelloPsConf'
break

#endregion


#region Demo DevOps

# VSteam by Donovan Brown https://github.com/DarqueWarrior/vsteam
import-module vsteam

# Set Organization
Set-VSTeamAccount -Account "az-new" # needs a PAT from DevOps

break

# See all projects in organization
Get-VSTeamProject

break

# Get all build
Get-VSTeamBuild -ProjectName "xaz.new"

break

# Get all Releases
Get-VSTeamRelease

break

# List work items
Get-VSTeamWorkItem -id 1

#endregion