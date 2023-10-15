# st-proxmox-templates

Proxmox Templates used in ST home lab environment.

Cleanup Ansible playbook is copied from [AlmaLinux cloud-images](https://github.com/AlmaLinux/cloud-images/) repository. This repository was big help in getting AlmaLinux template to work with Proxmox. 

## Templates

| Name | OS | Description |
| :---: | :---: | :---: |
|AlmaLinux 9 Stock | AlmaLinux 9 | Stock AlmaLinux 9 template with CIS Level 1 Benchmark enabled by default. |
|Windows Server 2022 Core DC Stock | Windows Server 2022 Datacenter| Stock Windows Server 2022 Core Datacenter template.|

## Usage

### Prerequisites

#### Windows

Following package need to be installed on Packer machine:  
| Package | Platform | Purpose |
| :---: | :----: | :---: |
| mkisofs | Linux | Build Autounattend iso file |
| oscdimg | Windows |  Build Autounattend iso file |
| hdiutil | macOS | Build Autounattend iso file |

### Possible issues

#### Windows

1. **Windows installation not silent or installation errors not related to disk**  
   You may need to change Autounattend.xml line break type to CRLF due to git converting it to LF.  
2. **Disk erros during installation**  
   Update DriverPaths (eg. change E: to F:) in Autounattend.xml.  
   You can press SHIFT+F10 to open cmd when you are on error screen and than change drives until you find the one with Virtio drivers on.  
   I plan to move drivers step to script installation to omit this issue.  
   When you find the correct drive it should be the same for future builds.
3. **EFI errors during the boot**  
   Check if your Windows ISO file is checked in Boot Order under Options menu of the VM. If not, update boot_order variable.
4. **Windows installation not booting**  
   Play around with boot_wait and boot_command.

### Manual

Using AlmaLinux 9 Stock as example.

See [doppler.sh](./secrets/doppler.sh) for variables you need to provide manually or by different secrets provider if you are not using Doppler.

Download and\or upgrade Packer plugin binaries:

```sh
packer init -upgrade .
```

Source secrets from Doppler:

```sh
source ./secrets/doppler.sh
```

Build Proxmox Template:

```sh
packer build --var-file=almalinux-9-proxmox.pkrvars.hcl almalinux-9-proxmox.pkr.hcl
```

Cleanup variables:

```sh
source ./secrets/doppler.sh cleanup
```

## License

Licensed under the MIT license, see the [LICENSE](LICENSE) file for details.