#!/bin/bash
set -xe

if [ ! -d /mnt/resource_nvme ]; then
    mkdir /mnt/resource_nvme
fi
# mdadm --create /dev/md10 --level 0 --raid-devices 2 /dev/nvme0n1 /dev/nvme1n1
parted /dev/nvme0n1 --script mklabel gpt mkpart xfspart xfs 0% 100%
# partprobe /dev/nvme0n1p1
mkfs.xfs /dev/nvme0n1p1
# mount /dev/md10 /mnt/resource_nvme
mount /dev/nvme0n1p1 /mnt/resource_nvme
chmod 1777 /mnt/resource_nvme
