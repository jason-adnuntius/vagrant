#!/bin/bash -eux

LOCKPWD=`dd if=/dev/urandom count=128 status=none | md5sum | awk -F' ' '{print $1}'`
printf "$LOCKPWD\n$LOCKPWD\n" | passwd root
passwd --lock root

