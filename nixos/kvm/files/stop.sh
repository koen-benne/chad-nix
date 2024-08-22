#!/run/current-system/sw/bin/bash

DATE=$(date +"%m/%d/%Y %R:%S :")

echo "$DATE Beginning of Teardown!"

## Unload VFIO-PCI driver ##
modprobe -r vfio
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1

sleep 10

virsh nodedev-detach pci_0000_0a_00_0
virsh nodedev-detach pci_0000_0a_00_1

echo 1 > /sys/class/vtconsole/vtcon0/bind
echo 1 > /sys/class/vtconsole/vtcon1/bind

modprobe amdgpu
modprobe snd_hda_intel

systemctl start greetd


echo "$DATE End of Teardown!"

