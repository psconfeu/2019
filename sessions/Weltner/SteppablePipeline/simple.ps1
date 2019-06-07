

$pipeline = { Out-GridView }.GetSteppablePipeline()
$pipeline.Begin($true)

$pipeline.Process("Here is your text")
Start-Sleep -Seconds 1
$pipeline.Process("Add as much as you want, when you want")
Start-Sleep -Seconds 1
$pipeline.Process("Just don't mix object types...")
Start-Sleep -Seconds 1
$pipeline.Process("When you are done, call End()")
$pipeline.End()

