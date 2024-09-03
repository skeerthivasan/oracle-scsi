#!/bin/bash

pvresize /dev/sda3
lvextend -r -L +20G /dev/mapper/sysvg-var
