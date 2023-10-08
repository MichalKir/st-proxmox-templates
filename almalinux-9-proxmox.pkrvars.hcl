vm_id                   = 9800
template_name           = "almalinux-9"
ssh_username            = "root"
template_description    = "AlmaLinux 9 Stock Template"
iso_file                = "local:iso/AlmaLinux-9.2-x86_64-minimal.iso"
iso_checksum            = "sha256:51ee8c6dd6b27dcae16d4c11d58815d6cfaf464eb0e7c75e026f8d5cc530b476"
os                      = "l26"
boot_command            = [
    "<wait10>",
    "<tab><wait>",
    "c<wait>",
    "linuxefi /images/pxeboot/vmlinuz",
    " inst.stage2=hd:LABEL=AlmaLinux-9-2-x86_64-dvd ro",
    " inst.text biosdevname=0 net.ifnames=0",
    " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/http/ks.cfg",
    "<enter>",
    "initrdefi /images/pxeboot/initrd.img",
    "<enter>",
    "boot<enter><wait>"
]