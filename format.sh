#!/run/current-system/sw/bin/bash

DISK_NAME=$1

parted ${DISK_NAME} -- mklabel gpt
parted ${DISK_NAME} -- mkpart root ext4 512MB -8GB
parted ${DISK_NAME} -- mkpart swap linux-swap -8GB 100%
parted ${DISK_NAME} -- mkpart ESP fat32 1MB 512MB
parted ${DISK_NAME} -- set 3 esp on
mkfs.ext4 -L nixos ${DISK_NAME}1
mkswap -L swap ${DISK_NAME}2
mkfs.fat -F 32 -n boot ${DISK_NAME}3

mount /dev/disk/by-label/nixos /mnt

mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/${DISK_NAME}/boot /mnt/boot
swapon ${DISK_NAME}2
