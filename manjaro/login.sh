#!/bin/bash

# this will login the console in, so we can then run commands without requiring to login again
name=$(cat vm.name)
sudo expect -c "
    set timeout 10
    spawn virsh console $name 
    expect {
	\"Escape character\" {send \"\r\r\" ; exp_continue} 
	\"Escape character\" {send \"\r\r\" ; exp_continue} 
	\"login:\" {send \"manjaro\r\"; exp_continue}
	\"Password:\" {send \"manjaro\r\";} 
	} 
	expect \"Last login: \"
	send \"\"
	expect eof
"

sudo virsh console $name

