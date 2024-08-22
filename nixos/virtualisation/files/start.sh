#!/run/current-system/sw/bin/bash

## Adds current time to var for use in echo for a cleaner log and script ##
DATE=$(date +"%m/%d/%Y %R:%S :")

echo "$DATE Beginning of Startup!"

systemctl stop greetd

sleep "1"

echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

sleep "1"

## Unload AMD GPU drivers ##
modprobe -r amdgpu
modprobe -r snd_hda_intel

echo "$DATE AMD GPU Drivers Unloaded"

virsh nodedev-detach pci_0000_0a_00_0
virsh nodedev-detach pci_0000_0a_00_1

sleep 10

## Load VFIO-PCI driver ##
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1

echo "$DATE End of Startup!"
# Helpful to read output when debugging
