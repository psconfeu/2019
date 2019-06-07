cls
Write-Host ([PSCustomObject]@{
  'Left Arrow + ENTER' = 'Show Member'
  'Right Arrow + ENTER' = 'Echo results'
  'Tab + ENTER' = 'Show all properties'
} | Format-List | Out-String)

function Out-Default
{
  param(
    [switch]
    ${Transcript},

    [Parameter(ValueFromPipeline=$true)]
    [psobject]
  ${InputObject})

  begin
  {
    $scriptCmd = {& 'Microsoft.PowerShell.Core\Out-Default' @PSBoundParameters }
    $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
    $steppablePipeline.Begin($PSCmdlet)
    Add-Type -AssemblyName WindowsBase
    Add-Type -AssemblyName PresentationCore
    $showGridView = [System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::Right)
    $showAllProps = [System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::Tab)
    $showMember = [System.Windows.Input.Keyboard]::IsKeyDown([System.Windows.Input.Key]::Left)
    
    if ($showGridView)
    {
      $cmd = {& 'Microsoft.PowerShell.Utility\Out-GridView' -Title (Get-Date -Format 'HH:mm:ss')  }
      $out = $cmd.GetSteppablePipeline()
      $out.Begin($true)
      
    }
    if ($showMember)
    {
      
      $cmd = {& 'Microsoft.PowerShell.Utility\Get-Member' | Select-Object -Property @{Name = 'Type';Expression = { $_.TypeName }}, Name, MemberType, Definition | Sort-Object -Property Type, {
        if ($_.MemberType -like '*Property')
        { 'B' }
        elseif ($_.MemberType -like '*Method')
        { 'C' }
        elseif ($_.MemberType -like '*Event')
        { 'A' }
        else
        { 'D' }
      }, Name | Out-GridView -Title Member  }
      $outMember = $cmd.GetSteppablePipeline()
      $outMember.Begin($true)
      
    }
    
  }

  process
  {
    $isError = $_ -is [System.Management.Automation.ErrorRecord]
    
    if ($showMember -and (-not $isError))
    {
      $outMember.Process($_)
    }
    if ($showAllProps -and (-not $isError))
    {
      $_ = $_ | Select-Object -Property *
    }
    if (($showGridView) -and (-not $isError))
    {
      $out.Process($_)
    }
    $steppablePipeline.Process($_)
  }

  end
  {
    $steppablePipeline.End()
    if ($showGridView)
    {
      $out.End()
    }
    if ($showMember)
    {
      $outMember.End()
    }
    
  }
}
