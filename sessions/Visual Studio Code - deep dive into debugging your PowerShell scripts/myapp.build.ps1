task Build {
    Write-Host "I AM BUILDING"
}

task Deploy Build, {
    Write-Host "🚀"
}
