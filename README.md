# st-proxmox-templates

Proxmox Templates used in ST home lab environment.

Cleanup Ansible playbook is copied from [AlmaLinux cloud-images](https://github.com/AlmaLinux/cloud-images/) repository. This repository was big help in getting AlmaLinux template to work with Proxmox. 

## Templates

| Name | OS | Description |
| :---: | :---: | :---: |
|AlmaLinux 9 Stock | AlmaLinux 9 | Stock AlmaLinux 9 template with CIS Level 1 Benchmark enabled by default. |

## Usage

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