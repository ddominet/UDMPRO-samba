# UDMPRO-samba

**UDM PRO SAMBA SERVER using drive bay**

**foreshadowing**

Hi, I recently acquired UDM PRO and wondered why can't I use this beautiful drive bay for something useful. Storing videos from proprietary cameras was not in my mind. So I begun to investigate and found out a great repo udm-utilities https://github.com/boostchicken/udm-utilities. I suggest you check it out because It will be useful in order to make this script work after reboot.

This script can be run by itself but I indended it to be used with on-boot-script from udm-utilities repo and placed in on_boot.d folder. Im using dperson/samba docker image https://hub.docker.com/r/dperson/samba

**START**

In order to run this script it is important to check what partition label did your drive recieve. Command ls /dev should list all devices UDM-PRO sees and on that list you should see both sda and sdb drives. UbiOS formats your entire drive in NFTS filesystem and in one partition. You should look for a drive that has only one partition. Second drive is used by udm and shouldn't be disturbed. Your UDM PRO should name your drive partition in the same way my is (which is sda1) but check it beforehand.

Having that warning in mind feel free to edit this script and it's variables.

You can run it in the shell manually but also use on_boot.d folder for it to work after every reboot.

Now only thing for you to do is to connect to UDMPRO samba server.

**smb://<your_udm_ip>/shared/**

Currently there is no authentication in order to access this drive but I might do it later. Feel free to edit this script if you want to add it yourself.

This script doesn't work if honey pots are enabled, because they use ports required for this to work Feel free to issue any pull requests.

#include <std_disclaimer.h>

/*
* You run this script at your own responsibility. It is not officialy supported
*/
