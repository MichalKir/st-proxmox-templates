#!/bin/bash
if [ "$1" == "cleanup" ]; then
    unset_vars=(
        PKR_VAR_proxmox_url
        PKR_VAR_proxmox_username
        PKR_VAR_proxmox_token
        PKR_VAR_proxmox_node
        PKR_VAR_mac_address
        PKR_VAR_ssh_password
        PKR_VAR_insecure_skip_tls_verify
        PKR_VAR_ansible_svc_ansible_public_key
        PKR_VAR_ansible_svc_ansible_password
        PROXMOX_API_URL
        PACKER_TOKEN_ID
        PACKER_TOKEN_SECRET
        PROXMOX_NODE
        PACKER_MAC_ADDRESS
        PACKER_ROOT_PASSWORD
        PACKER_SKIP_TLS
        SVC_ANSIBLE_PUBLIC_KEY
        SVC_ANSIBLE_PASSWORD_SHA512
    )
    for var in "${unset_vars[@]}"; do
        unset "$var"
    done
    exit 0
fi

source <(doppler secrets download --no-file --format env -p proxmox -c prd)
export PKR_VAR_proxmox_url=$PROXMOX_API_URL
export PKR_VAR_proxmox_username=$PACKER_TOKEN_ID
export PKR_VAR_proxmox_token=$PACKER_TOKEN_SECRET
export PKR_VAR_proxmox_node=$PROXMOX_NODE
export PKR_VAR_mac_address=$PACKER_MAC_ADDRESS
export PKR_VAR_ssh_password=$PACKER_ROOT_PASSWORD
export PKR_VAR_insecure_skip_tls_verify=$PACKER_SKIP_TLS
export PKR_VAR_ansible_svc_ansible_public_key=$SVC_ANSIBLE_PUBLIC_KEY
export PKR_VAR_ansible_svc_ansible_password=$SVC_ANSIBLE_PASSWORD_SHA512
