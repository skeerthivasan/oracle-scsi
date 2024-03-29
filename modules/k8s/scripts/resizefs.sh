#!/bin/bash
/usr/sbin/pvresize /dev/sdb
/sbin/lvextend -L +200G -r /dev/mapper/sysvg-root

