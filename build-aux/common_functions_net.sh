#! /bin/bash

check_connection(){ 
echo "check connection EUID $EUID"
wget  --tries=1 --timeout=3 \
    http://www.google.com -O /tmp/index.google &> /dev/null  || true
if [ ! -s /tmp/index.google ];then 
    return 1 # 1 sale
else
    unlink /tmp/index.google 
    return 0
fi
}

check_wireless(){
if [[ $EUID -gt 0 ]];then
echo "need to be root "
sudo $script_dir/wifi.sh $file_connections
fi
return 0
}


