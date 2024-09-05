#!/bin/bash

# Determine the OS type
OS=$(uname)

if [ "$OS" = "Linux" ]; then
    # Check Linux distribution from /etc/os-release
    if [ -f "/etc/os-release" ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        echo "Cannot determine Linux distribution. /etc/os-release not found."
        exit 1
    fi

    case "$DISTRO" in
        ubuntu)
            echo "Running on Ubuntu"
            # Commands specific to Ubuntu
            (
            echo d # Delete  partition
            echo   # default partition
            echo n # Add a new partition
            echo   # default partition
            echo   # default
            echo   # default 
            echo w # Write changes
            ) | fdisk /dev/sda
            pvresize /dev/sda3
            lvextend -r -L +20G /dev/mapper/sysvg-var
            lvextend -r -L +10G /dev/mapper/sysvg-root
            lvextend -r -L +5G /dev/mapper/sysvg-opt
            lvextend -r -L +5G /dev/mapper/sysvg-home
            lvextend -r -L +5G /dev/mapper/sysvg-tmp
            lvextend -r -L +5G /dev/mapper/sysvg-log
            ;;
        rhel)
            echo "Running on Red Hat Enterprise Linux"
            # Commands specific to RHEL
            ;;
        *)
            echo "Unknown Linux distribution: $DISTRO"
            # Default or fallback commands for unknown distros
            ;;
    esac
else
    echo "Unknown operating system: $OS"
    # Default or fallback commands for unknown OS
fi