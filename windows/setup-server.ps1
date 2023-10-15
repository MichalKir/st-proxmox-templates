$ErrorActionPreference = "Stop"
# WinRM
Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private
Get-NetFirewallRule -DisplayGroup "Windows Remote Management" | Enable-NetFirewallRule
Set-WSManQuickConfig -Force
Enable-PSRemoting -Force -Confirm:$false
Set-WSManInstance -ResourceURI winrm/config/client/auth -ValueSet @{Basic="true"} 
Set-WSManInstance -ResourceURI winrm/config/service/auth -ValueSet @{Basic="true"} 
Set-WSManInstance -ResourceURI winrm/config/service -ValueSet @{AllowUnencrypted="true"}

# Update VirtIO Drivers
$virtioIsoDriversPath = Join-Path -Path $env:temp -ChildPath "virtio-win.iso"
Start-BitsTransfer -Source "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso" -Description $virtioIsoDriversPath

$virtioIsoMount = Mount-DiskImage -ImagePath $virtioIsoDriversPath -StorageType ISO
$virtioIsoMountDrive = ($virtioIsoMount | Get-Volume).DriveLetter, ":" -join ""
Get-ChildItem -Path $virtioIsoMountDrive -Include "qemu-ga-x86_64.msi", "virtio-win-gt-x64.msi" -Recurse | ForEach-Object {
    Start-Process -FilePath msiexec -ArgumentList "/i `"$($_.FullName)`" /qn /norestart ADDLOCAL=ALL" -Wait -PassThru -NoNewWindow
}
$virtioIsoMount | Dismount-DiskImage
Start-Service -Name QEMU-GA

# Reset Winlogon Count
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -Name AutoLogonCount -Value 0