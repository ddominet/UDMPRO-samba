
#!/bin/sh

# variables (set the name of partition you want to use and how you want to name the container)

DRIVE="sda1"
container_name="samba"

# network config and startup

CNI_PATH=/mnt/data/podman/cni
if [ ! -f "$CNI_PATH"/macvlan ]; then
    mkdir -p $CNI_PATH
    curl -L https://github.com/containernetworking/plugins/releases/download/v0.8.6/cni-plugins-linux-arm64-v0.8.6.tgz | tar -xz -C $CNI_PATH
fi

mkdir -p /opt/cni
rm -f /opt/cni/bin
ln -s $CNI_PATH /opt/cni/bin

for file in "$CNI_PATH"/*.conflist
do
    if [ -f "$file" ]; then
        ln -s "$file" "/etc/cni/net.d/$(basename "$file")"
    fi
done

# mounting and creating shared file if it doesnt exit

if [ ! -d /mnt/drive ]; then
    mkdir /mnt/drive
    mount /dev/$DRIVE /mnt/drive
fi

FILE=/mnt/drive/share

if [ ! -d "$FILE" ]; then
    mkdir $FILE
    chmod 7777 $FILE
fi

# starting the container

CID=$(podman ps -all -q -f status=created -f name=samba)
if [ ! "${CID}" ]; then
  podman run --name ${container_name} -p 139:139 -p 445:445 -p 137:137/udp -p 138:138/udp -v "$FILE:/share:Z" -d dperson/samba -n -s "shared;/share;yes;no;yes;all;none;none;Shared files" -p -g "usershare allow guests = yes" -g "map to guest = bad user" -g "load printers = no" -g "printcap cache time = 0" -g "printing = bsd" -g "printcap name = /dev/null" -g "disable spoolss = yes"
else 
  podman rm $CID
  podman run --name ${container_name} -p 139:139 -p 445:445 -p 137:137/udp -p 138:138/udp -v "$FILE:/share:Z" -d dperson/samba -n -s "shared;/share;yes;no;yes;all;none;none;Shared files" -p -g "usershare allow guests = yes" -g "map to guest = bad user" -g "load printers = no" -g "printcap cache time = 0" -g "printing = bsd" -g "printcap name = /dev/null" -g "disable spoolss = yes"
fi
unset CID




