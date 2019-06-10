#region  1- Prepare powerShell to run
	#Install dependencies
	sudo apt-get install libunwind8

	#make room for the beast!
	mkdir ~/powershell

	#download the latest version
		#wget https://github.com/PowerShell/PowerShell/releases/download/v6.2.0/powershell-6.2.0-linux-arm32.tar.gz

	#I've already downloaded to save time, so let's use that instead
	cp /home/pi/Documents/backup/powershell-6.2.0-linux-arm32.tar.gz /home/pi/Documents/Presentation/

	#Extract the content
	tar -xvf /home/pi/Documents/Presentation/powershell-6.2.0-linux-arm32.tar.gz -C ~/powershell

	# Let the fun begin!
	~/powershell/pwsh

	# Let's avoid the need to specify the full path...
	sudo ln -s ~/powershell/pwsh /usr/bin/pwsh

	$PSVersionTable
	Get-Module
	Get-Process
#endregion

#region 2- Microsoft.PowerShell.IoT

sudo pwsh # sudo is required because because we will interact with hardware.
Install-Module Microsoft.PowerShell.IoT

Import-Module Microsoft.PowerShell.IoT

Get-Command -Module Microsoft.PowerShell.IoT

Get-Help -Module Get-Gpio
#endregion

#region 3 - Let's take a quick look into a module that I've developed based on the IoT one
# https://github.com/DanielSSilva/PowerShell-IoT---IS31FL3730-Driver
cp -r /home/pi/Documents/backup/ScrollpHat/PowerShell-IoT---IS31FL3730-Driver /home/pi/Documents/Presentation

./Initialize_SadJoey.ps1

./simple_Setup.ps1
#endregion

#region 4 - Let's configure the ssh server on the pi to allow remote connections.
Write-Host 'swich to 2_remote_debug.md file'
#endregion