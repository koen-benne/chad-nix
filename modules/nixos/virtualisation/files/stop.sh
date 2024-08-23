#!/run/current-system/sw/bin/bash

DATE=$(date +"%m/%d/%Y %R:%S :")

echo "$DATE Beginning of Teardown!"

## Unload VFIO-PCI driver ##
modprobe -r vfio_pci
modprobe -r vfio_iommu_type1
modprobe -r vfio

echo "$DATE Loading AMD GPU Drivers"

modprobe amdgpu
modprobe radeon

echo "$DATE AMD GPU Drivers Loaded"

systemctl start greetd

input="/tmp/vfio-bound-consoles"
while read -r consoleNumber; do
  if test -x /sys/class/vtconsole/vtcon"${consoleNumber}"; then
      if [ "$(grep -c "frame buffer" "/sys/class/vtconsole/vtcon${consoleNumber}/name")" \
           = 1 ]; then
    echo "$DATE Rebinding console ${consoleNumber}"
	  echo 1 > /sys/class/vtconsole/vtcon"${consoleNumber}"/bind
      fi
  fi
done < "$input"


echo "$DATE End of Teardown!"

