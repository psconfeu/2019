param (
    $Path
)
###############################################################################
# Dot source the import of module
###############################################################################
. $PSScriptRoot\shared.ps1

if ($path) {
    $armTemplate = $path
}
else {
    $armTemplate = Get-xAzCosmosTemplate
}

Describe "test arm template $armTemplate" -Tag Unit {


    $null = Test-Path $armTemplate -ErrorAction Stop

    $TemplateFolder = Get-ChildItem (Split-Path $armTemplate -Parent)

    try {
        $text = Get-Content $armTemplate -Raw -ErrorAction Stop
    }
    catch {
        Write-Error "$($_.Exception) found"
        Write-Error "$($_.ScriptStackTrace)"
        break
    }

    try {
        $json = ConvertFrom-Json $text -ErrorAction Stop
    }
    catch {
        $JsonException = $_
    }


    it "should throw no expection" {
        $JsonException | Should -BeNullOrEmpty
    }

    it "should have content" {
        $json | Should -Not -BeNullOrEmpty
    }

    it "should have metadata.json" {
        $TemplateFolder | Where-Object Name -match 'metadata.json' | Should -BeLike "*metadata.json"
    }

    it "should have parameters.json" {
        $TemplateFolder | Where-Object Name -match 'parameters.json' | Should -BeLike "*parameters.json"
    }

    $TestCases = @(
        @{
            Expected = "parameters"
        },
        @{
            Expected = "variables"
        },
        @{
            Expected = "resources"
        },
        @{
            Expected = "outputs"
        }
    )

    it "should have <Expected>" -TestCases $TestCases {
        param(
            $Expected
        )

        $json.PSObject.Members.Name | Should -Contain $Expected
        # $json.$Expected | Should -Not -BeNullOrEmpty
    }

    context "parameters tests" {
        $parameters = $json.parameters | Get-Member -MemberType NoteProperty
        if ($parameters) {
            foreach ($parameter in $parameters) {
                $ParameterName = $($parameter.Name)
                it "$ParameterName should have metadata" {
                    $json.parameters.$ParameterName.metadata | Should -Not -BeNullOrEmpty
                }
            }
        }
        else {
            Write-Warning "Could NOT find parameters"
        }

    }

    context "resources tests" {
        foreach ($resource in $json.resources) {
            $type = $resource.type
            it "$type should have comment" {
                $resource.comments  | Should -Not -BeNullOrEmpty
            }
        }
    }

    context "resources structure test" {
        foreach ($resource in $json.resources) {
            it "should follow comment > type > apiVersion > name > properties" {
                "$resource" | Should -BeLike "*comments*type*apiVersion*name*properties*"
            }
        }
    }
}

