# PowerShell Remoting Over SSH

	https://github.com/PowerShell/PowerShell-IoT/blob/master/docs/remoting.md

	(this is required because of the service sshd restart)
	(I've already done this because I have no internet access)
	sudo apt-get purge openssh-server && sudo apt-get install openssh-server

	sudo nano /etc/ssh/sshd_config

Enable password authentication

	PasswordAuthentication yes

Add PowerShell subsystem entry

	Subsystem powershell sudo pwsh -sshs -NoLogo -NoProfile
	sudo service sshd restart


https://github.com/PowerShell/vscode-powershell/blob/master/docs/remoting.md#remote-file-editing-with-open-editorfile