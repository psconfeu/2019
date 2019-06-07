Describe 'Requirements for Windows Authentication:' {
    It 'Windows Authentication should be enabled on the IIS website used to host Universal Dashboard' {
        $windowsAuth = Get-WebConfigurationProperty -Filter //windowsAuthentication -PSPath 'IIS:\Sites\Default Web Site' -Name Enabled
        $windowsAuth.Value | Should -BeTrue
    }

    It 'forwardWindowsAuthToken should be set to true in web.config' {
        Select-Xml -Path C:\inetpub\wwwroot\web.config -XPath '/configuration/system.webServer/aspNetCore[@forwardWindowsAuthToken="true"]' | Should -BeTrue
    }
}

Start-UDDashboard -Content {
    $Auth = New-UDAuthenticationMethod -Windows
    $LoginPage = New-UDLoginPage -AuthenticationMethod @($Auth) -PassThru

    New-UDDashboard -Title "Windows Integrated Authentication Demo" -Color '#FF050F7F' -Content { 
        New-UDRow -Columns {
            New-UDColumn -Size 12 -Endpoint {
                New-UDCard -Text "Logged in as $user" -TextSize Large
            }
        }
    } -LoginPage $LoginPage
} -Wait -AllowHttpForLogin

