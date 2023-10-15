#!/bin/bash
if [ "$1" == "cleanup" ]; then
    sed -i "s/${SSH_PASSWORD}/REPLACE_ROOT_PASSWORD/g" ./http/ks.cfg
    unset_vars=(
        ANSIBLE_SVC_ANSIBLE_PASSWORD
        ANSIBLE_SVC_ANSIBLE_PUBLIC_KEY
        INSECURE_SKIP_TLS_VERIFY
        MAC_ADDRESS
        PROXMOX_NODE
        PROXMOX_TOKEN
        PROXMOX_URL
        PROXMOX_USERNAME
        SSH_PASSWORD
        WINRM_PASSWORD
        WINRM_USERNAME
        PKR_VAR_ansible_svc_ansible_password
        PKR_VAR_ansible_svc_ansible_public_key
        PKR_VAR_insecure_skip_tls_verify
        PKR_VAR_mac_address
        PKR_VAR_proxmox_node
        PKR_VAR_proxmox_token
        PKR_VAR_proxmox_url
        PKR_VAR_proxmox_username
        PKR_VAR_ssh_password
        PKR_VAR_winrm_password
        PKR_VAR_winrm_username
    )
    for var in "${unset_vars[@]}"; do
        unset "$var"
    done
    return
fi

source <(doppler secrets download --no-file --format env -p packer -c prd)
sed -i "s/REPLACE_ROOT_PASSWORD/${SSH_PASSWORD}/g" ./http/ks.cfg
export PKR_VAR_ansible_svc_ansible_password=$ANSIBLE_SVC_ANSIBLE_PASSWORD
export PKR_VAR_ansible_svc_ansible_public_key=$ANSIBLE_SVC_ANSIBLE_PUBLIC_KEY
export PKR_VAR_insecure_skip_tls_verify=$INSECURE_SKIP_TLS_VERIFY
export PKR_VAR_mac_address=$MAC_ADDRESS
export PKR_VAR_proxmox_node=$PROXMOX_NODE
export PKR_VAR_proxmox_token=$PROXMOX_TOKEN
export PKR_VAR_proxmox_url=$PROXMOX_URL
export PKR_VAR_proxmox_username=$PROXMOX_USERNAME
export PKR_VAR_ssh_password=$SSH_PASSWORD
export PKR_VAR_winrm_password=$WINRM_PASSWORD
export PKR_VAR_winrm_username=$WINRM_USERNAME
