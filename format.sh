#!/run/current-system/sw/bin/bash

set -e

DISK_NAME=$1

# Create partitions
parted -s ${DISK_NAME} -- mklabel gpt
parted -s ${DISK_NAME} -- mkpart root ext4 512MB -8GB
parted -s ${DISK_NAME} -- mkpart swap linux-swap -8GB 100%
parted -s ${DISK_NAME} -- mkpart ESP fat32 1MB 512MB
parted -s ${DISK_NAME} -- set 3 esp on

# Format all the partitions
mkfs.ext4 -L nixos ${DISK_NAME}p1
mkswap -L swap ${DISK_NAME}p2
mkfs.fat -F 32 -n boot ${DISK_NAME}p3

mount /dev/disk/${DISK_NAME}p1/nixos /mnt

mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/${DISK_NAME}p3/boot /mnt/boot
swapon ${DISK_NAME}p2
