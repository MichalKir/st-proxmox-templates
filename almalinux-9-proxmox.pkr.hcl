locals {
  template_timestamp = formatdate("YYYYMMDD-hhmm", timestamp())
}

source "proxmox-iso" "almalinux-9-stock" {
  boot_command              = var.boot_command
  insecure_skip_tls_verify  = var.insecure_skip_tls_verify
  vm_id                     = var.vm_id
  template_name             = "${var.template_name}-stock.${local.template_timestamp}"
  template_description      = var.template_description
  username                  = var.proxmox_username
  token                     = var.proxmox_token
  proxmox_url               = var.proxmox_url
  node                      = var.proxmox_node
  iso_file                  = var.iso_file
  iso_checksum              = var.iso_checksum
  os                        = var.os
  memory                    = var.memory
  ballooning_minimum        = var.ballooning_minimum
  ssh_username              = var.ssh_username
  ssh_password              = var.ssh_password
  cores                     = var.cores
  cpu_type                  = var.cpu_type
  sockets                   = var.sockets
  scsi_controller           = var.scsi_controller
  disks {
    cache_mode              = var.disks.cache_mode
    disk_size               = var.disks.disk_size
    format                  = var.disks.format
    storage_pool            = var.disks.storage_pool
    type                    = var.disks.type
  }
  network_adapters {
    bridge                  = var.network_adapters.bridge
    model                   = var.network_adapters.model
    firewall                = var.network_adapters.firewall
    mac_address             = var.mac_address
    vlan_tag                = var.network_adapters.vlan_tag
  }
  ssh_port                  = var.ssh_port
  ssh_timeout               = var.ssh_timeout
  boot_wait                 = var.boot_wait
  boot                      = var.boot
  disable_kvm               = var.disable_kvm
  cloud_init                = true
  cloud_init_storage_pool   = var.disks.storage_pool
  bios                      = var.bios
  efi_config {
    efi_storage_pool        = var.disks.storage_pool
    pre_enrolled_keys       = var.efi_config.pre_enrolled_keys
    efi_type                = var.efi_config.efi_type
  }
  unmount_iso               = var.unmount_iso
  task_timeout              = var.task_timeout
  qemu_agent                = var.qemu_agent
  http_directory            = "${path.cwd}"
  machine                   = "q35"
}

build {
  sources = [
    "proxmox-iso.almalinux-9-stock"
  ]

  provisioner "ansible" {
    playbook_file    = "./ansible/almalinux/stock.yml"
    galaxy_file      = "./ansible/almalinux/requirements.yml"
    roles_path       = "./ansible/almalinux/roles"
    extra_arguments  = [
      "-v",
      "-e svc_ansible_public_key='${var.ansible_svc_ansible_public_key}'",
      "-e svc_ansible_password='${var.ansible_svc_ansible_password}'",
      "--ssh-extra-args",
      "-o HostKeyAlgorithms=+ssh-rsa",
      "--scp-extra-args",
      "'-O'"
    ]
  }
}

## ====================
# Variable definitions
## ====================
variable "boot_command" {
  type      = list(string)
  default   = []
}

variable "insecure_skip_tls_verify" {
  type      = bool
  default   = false
}

variable "vm_id" {
  type      = string
  default   = ""
}

variable "template_name" {
  type      = string
  default   = ""
}

variable "template_description" {
  type      = string
  default   = ""
}

variable "proxmox_username" {
  type      = string
  default   = ""
}

variable "proxmox_token" {
  type      = string
  sensitive = true
  default   = ""
}

variable "proxmox_url" {
  type      = string
  default   = ""
}

variable "proxmox_node" {
  type      = string
  default   = "kanto1"
}

variable "iso_file" {
  type      = string
  default   = ""
}

variable "iso_checksum" {
  type      = string
  default   = ""
}

variable "os" {
  type      = string
  default   = ""
}

variable "ansible_svc_ansible_public_key" {
  type      = string
  default   = ""
}

variable "ansible_svc_ansible_password" {
  type      = string
  sensitive = true
  default   = ""
}

variable "mac_address" {
  type      = string
  default   = ""
}

variable "ssh_username" {
  type      = string
  default   = ""
}

variable "ssh_password" {
  type      = string
  sensitive = true
  default   = ""
}

variable "memory" {
  type      = string
  default   = "4096"
}

variable "ballooning_minimum" {
  type      = string
  default   = "2048"
}

variable "cores" {
  type      = string
  default   = "4"
}

variable "cpu_type" {
  type      = string
  default   = "x86-64-v2-AES"
}

variable "sockets" {
  type      = string
  default   = "1"
}

variable "scsi_controller" {
  type      = string
  default   = "virtio-scsi-single"
}

variable "disks" {
  type = object({
    cache_mode        = string
    disk_size         = string
    format            = string
    storage_pool      = string
    type              = string
  })
  default = {
    cache_mode        = "writeback"
    disk_size         = "35G"
    format            = "raw"
    storage_pool      = "os_pool"
    storage_pool_type = "zfspool"
    type              = "virtio"
  }
}

variable "network_adapters" {
  type = object({
    bridge              = string
    model               = string
    firewall            = bool
    vlan_tag            = string
  })
  default = {
    bridge              = "vmbr1"
    model               = "virtio"
    firewall            = false
    vlan_tag            = 5
  }
}

variable "ssh_port" {
  type      = number
  default   = 22
}

variable "ssh_timeout" {
  type      = string
  default   = "20m"
}

variable "boot_wait" {
  type      = string
  default   = "10s"
}

variable "boot" {
  type      = string
  default   = "order=virtio0;ide2;ide0"
}

variable "disable_kvm" {
  type      = bool
  default   = false
}

variable "bios" {
  type      = string
  default   = "ovmf"
}

variable efi_config {
  type = object({
    pre_enrolled_keys   = bool
    efi_type            = string
  })
  default = {
    pre_enrolled_keys   = true
    efi_type            = "4m"
  }
}

variable "unmount_iso" {
  type      = bool
  default   = true
}
variable "task_timeout" {
  type      = string
  default   = "20m"
}

variable "qemu_agent" {
  type      = bool
  default   = true
}
