vm_id                           = 9850
template_name                   = "windows-server-2022-dc"
template_description            = "Windows Server 2022 Data Center Stock Template"
iso_file                        = "local:iso/en-us_windows_server_2022_updated_sep_2023_x64_dvd_892eeda9.iso"
iso_checksum                    = "sha256:DCA37DAF2D801D05AEB43D4A87A44229407EDE1E33748A6D1F1FA443D4DB886E"
iso_virtio_drivers              = "local:iso/virtio-win-0.1.240.iso"
iso_virtio_drivers_checksum     = "sha256:EBD48258668F7F78E026ED276C28A9D19D83E020FFA080AD69910DC86BBCBCC6"
os                              = "win11"
boot_command                    = [
    "<wait1s><space>",
    "<wait1s><space>",
    "<wait1s><space>",
    "<wait1s><space>",
    "<wait1s><space>",
    "<wait1s><space>",
    "<wait1s><space>",
    "<wait1s><space>",
    "<wait1s><space>",
    "<wait1s><enter>"
]
boot_wait                       = "5s"
