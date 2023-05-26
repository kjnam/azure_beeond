#!/bin/bash
set -xe
MOUNT_ROOT=${1:-/mnt/resource_nvme}
# this script needs to run without sudo
#  - the keys from the user are used for the root user

sudo wget -O /etc/yum.repos.d/beegfs-rhel8.repo https://www.beegfs.io/release/beegfs_7.3.3/dists/beegfs-rhel8.repo
sudo rpm --import https://www.beegfs.io/release/beegfs_7.3.3/gpg/GPG-KEY-beegfs

sudo yum install -y epel-release
sudo yum install -y psmisc libbeegfs-ib beeond pdsh pdsh-rcmd-ssh

sudo sed -i 's/^buildArgs=-j8/buildArgs=-j8 BEEGFS_OPENTK_IBVERBS=1 OFED_INCLUDE_PATH=\/usr\/src\/ofa_kernel\/default\/include/g' /etc/beegfs/beegfs-client-autobuild.conf

sudo /etc/init.d/beegfs-client rebuild || exit 1

sudo cp -r $HOME/.ssh /root/.

sudo mkdir $MOUNT_ROOT/beeond
sudo chmod 777 $MOUNT_ROOT/beeond
sudo mkdir /beeond
sudo chmod 777 /beeond
cat << EOF | sudo tee > /etc/pdsh/rcmd_default
ssh
EOF
