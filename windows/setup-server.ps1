$ErrorActionPreference = "Stop"
$logPath = Join-Path -Path [IO.Path]::Combine($env:windir, "Temp", "packer.log")

Start-Sleep -Seconds 5

# Update VirtIO Drivers
"Downloading virtio drivers" >> $logPath
$virtioIsoDriversPath = Join-Path -Path $env:temp -ChildPath "virtio-win.iso"
Start-BitsTransfer -Source "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso" -Description $virtioIsoDriversPath

"Mounting virtio drivers iso" >> $logPath
$virtioIsoMount = Mount-DiskImage -ImagePath $virtioIsoDriversPath -StorageType ISO
$virtioIsoMountDrive = ($virtioIsoMount | Get-Volume).DriveLetter, ":" -join ""
"Installing virtio drivers and qemu guest agent" >> $logPath
Get-ChildItem -Path $virtioIsoMountDrive -Include "qemu-ga-x86_64.msi", "virtio-win-gt-x64.msi" -Recurse | ForEach-Object {
    Start-Process -FilePath msiexec -ArgumentList "/i `"$($_.FullName)`" /qn /norestart ADDLOCAL=ALL" -Wait -PassThru -NoNewWindow
}
"Unmounting virtio drivers" >> $logPath
$virtioIsoMount | Dismount-DiskImage
"Starting qemu guest agent" >> $logPath
Start-Service -Name QEMU-GA

# Reset Winlogon Count
"Reseting WinLogon count" >> $logPath
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0

# WinRM
"Setting Network profile to Private" >> $logPath
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
"Enabling Windows Remote Management firewall rule" >> $logPath
Get-NetFirewallRule -DisplayGroup "Windows Remote Management" | Enable-NetFirewallRule
"Configuring WSMan" >> $logPath
Set-WSManQuickConfig -Force
"Configuring PSRemoting" >> $logPath
Enable-PSRemoting -Force -Confirm:$false
"Configuring WinRM to allow connection from Packer"
Set-WSManInstance -ResourceURI winrm/config/client/auth -ValueSet @{Basic=$true} 
Set-WSManInstance -ResourceURI winrm/config/service/auth -ValueSet @{Basic=$true} 
Set-WSManInstance -ResourceURI winrm/config/service -ValueSet @{AllowUnencrypted=$true}
"Resetting WinRM service" >> $logPath
Restart-Service -Name winrm