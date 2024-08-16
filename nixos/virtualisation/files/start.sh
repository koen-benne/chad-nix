#!/run/current-system/sw/bin/bash

#############################################################################
##     ______  _                _  _______         _                 _     ##
##    (_____ \(_)              | |(_______)       | |               | |    ##
##     _____) )_  _   _  _____ | | _    _   _   _ | |__   _____   __| |    ##
##    |  ____/| |( \ / )| ___ || || |  | | | | | ||  _ \ | ___ | / _  |    ##
##    | |     | | ) X ( | ____|| || |__| | | |_| || |_) )| ____|( (_| |    ##
##    |_|     |_|(_/ \_)|_____) \_)\______)|____/ |____/ |_____) \____|    ##
##                                                                         ##
#############################################################################
###################### Credits ###################### ### Update PCI ID'S ###
## Lily (PixelQubed) for editing the scripts       ## ##                   ##
## RisingPrisum for providing the original scripts ## ##   update-pciids   ##
## Void for testing and helping out in general     ## ##                   ##
## .Chris. for testing and helping out in general  ## ## Run this command  ##
## WORMS for helping out with testing              ## ## if you dont have  ##
##################################################### ## names in you're   ##
## The VFIO community for using the scripts and    ## ## lspci feedback    ##
## testing them for us!                            ## ## in your terminal  ##
##################################################### #######################

################################# Variables #################################

## Adds current time to var for use in echo for a cleaner log and script ##
DATE=$(date +"%m/%d/%Y %R:%S :")

## Sets dispmgr var as null ##
DISPMGR="null"

################################## Script ###################################

echo "$DATE Beginning of Startup!"


systenctl stop greetd


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

if lspci -nn | grep -e VGA | grep -s AMD ; then
    echo "$DATE System has an AMD GPU"
    grep -qsF "true" "/tmp/vfio-is-amd" || echo "true" >/tmp/vfio-is-amd
    echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

    ## Unload AMD GPU drivers ##
    modprobe -r amdgpu

    echo "$DATE AMD GPU Drivers Unloaded"
fi

## Load VFIO-PCI driver ##
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1

echo "$DATE End of Startup!"
# Helpful to read output when debugging
