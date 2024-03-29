#!/bin/bash
/usr/sbin/pvresize /dev/sdb
/sbin/lvextend -L +120G -r /dev/mapper/sysvg-root
/sbin/lvextend -L +20G -r /dev/mapper/sysvg-var
/sbin/lvextend -L +20G -r /dev/mapper/sysvg-opt
/sbin/lvextend -L +20G -r /dev/mapper/sysvg-tmp
/sbin/lvextend -L +10G -r /dev/mapper/sysvg-log
/sbin/lvextend -L +10G -r /dev/mapper/sysvg-home

