#!/run/current-system/sw/bin/bash

## Adds current time to var for use in echo for a cleaner log and script ##
DATE=$(date +"%m/%d/%Y %R:%S :")

echo "$DATE Beginning of Startup!"

systemctl stop greetd

## Unbind EFI-Framebuffer ##
rm -f /tmp/vfio-is-amd

sleep "1"

if test -e "/tmp/vfio-bound-consoles"; then
    rm -f /tmp/vfio-bound-consoles
fi
for (( i = 0; i < 16; i++))
do
  if test -x /sys/class/vtconsole/vtcon"${i}"; then
      if [ "$(grep -c "frame buffer" /sys/class/vtconsole/vtcon"${i}"/name)" = 1 ]; then
	       echo 0 > /sys/class/vtconsole/vtcon"${i}"/bind
           echo "$DATE Unbinding Console ${i}"
           echo "$i" >> /tmp/vfio-bound-consoles
      fi
  fi
done

sleep "1"

echo "$DATE System has an AMD GPU"
grep -qsF "true" "/tmp/vfio-is-amd" || echo "true" >/tmp/vfio-is-amd

## Unload AMD GPU drivers ##
modprobe -r amdgpu
modprobe -r radeon

echo "$DATE AMD GPU Drivers Unloaded"

## Load VFIO-PCI driver ##
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1

echo "$DATE End of Startup!"
# Helpful to read output when debugging
