#!/bin/bash

rootcount=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
rootcount=$(($rootcount-1))
dd if=/dev/zero of=/zerofill bs=1K count=$rootcount || echo "dd exit code $? suppressed"
rm --force /zerofill
