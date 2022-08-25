#!/bin/bash
#set -x

# Shutdown all the nodes!  This is important otherwise the data will not be consistent!
sudo systemctl stop dashd01 dashd02 dashd03
while pidof dashd;do sleep 1;done

files=$(sudo find /home/dash01/.dashcore/blocks -type f -name "blk*"|sort|head -$(($(sudo find /home/dash01/.dashcore/blocks -type f -name "blk*"|wc -l)-1)))
files+=$(echo;sudo find /home/dash01/.dashcore/blocks -type f -name "rev*"|sort|head -$(($(sudo find /home/dash01/.dashcore/blocks -type f -name "rev*"|wc -l)-1)))

# Only do the below if the $files variable contains elements.
((${#files}==0))&&exit 1

for f in $files;do sudo mv -v $f /home/dash-common/.dashcore/blocks/;done
sudo chmod -v -R g+wrx /home/dash-common/.dashcore/blocks/
sudo chown -vR dash-common:dash-common /home/dash-common/.dashcore/blocks/

for f in $files;do sudo ln -vs "../../../dash-common/.dashcore/blocks/$(basename $f)" "/home/dash01/.dashcore/blocks/$(basename $f)";done
sudo chown -Rv dash01:dash01 /home/dash01/.dashcore/blocks/

for i in {02..03};do
	sudo rm /tmp/[do][an][si][ho]*[ok][ne][fy]
	sudo bash -c "cp -v /home/dash$i/.dashcore/[do][an][si][ho]*[ok][ne][fy] /tmp/" &&\
	{ sudo rm -fr /home/dash$i/.dashcore/
	sudo cp -va /home/dash01/.dashcore /home/dash$i
	sudo bash -c "rm -fr /home/dash$i/.dashcore/{.lock,.walletlock,d*.log,*.dat,onion*key} /home/dash$i/.dashcore/backups/"
	sudo cp -v /tmp/[do][an][si][ho]*[ok][ne][fy] /home/dash$i/.dashcore/
	sudo chown -v -R dash$i:dash$i /home/dash$i/;}
done

# Just reboot and all the nodes will come back on-line themselves.
read -r -s -n1 -p "Press any key to reboot... "
sudo reboot

