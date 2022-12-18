#!/bin/bash
#set -x

# Important! Change this variable to the name of your first dash user.
dash1=dash01

# Important! Change this variable to the prefix for your second, third, ... etc
# dash user, eg if you have dash01, dash02, enter dash0 here, if you have
# mn1, mn2, then enter mn here, the script will append the numbers, 2,3,4, etc.
dashx=dash0

# Important, enter the number of dash users you have here, eg 3 for three nodes
# in total.
num_nodes=3

# Shutdown all the nodes!  This is important otherwise the data will not be consistent!
for((i=1;i<=num_nodes;i++));do
	echo "Shutting down $dashx$i..."
	sudo systemctl stop dashd0$i
done

while pidof dashd;do sleep 1;done

files=$(sudo find /home/$dash1/.dashcore/blocks -type f -name "blk*"|sort|head -$(($(sudo find /home/$dash1/.dashcore/blocks -type f -name "blk*"|wc -l)-1)))
files+=$(echo;sudo find /home/$dash1/.dashcore/blocks -type f -name "rev*"|sort|head -$(($(sudo find /home/$dash1/.dashcore/blocks -type f -name "rev*"|wc -l)-1)))

# Only do the below if the $files variable contains elements.
((${#files}==0))&&exit 1

for f in $files;do sudo mv -v $f /home/dash-common/.dashcore/blocks/;done
sudo chmod -v -R g+wrx /home/dash-common/.dashcore/blocks/
sudo chown -vR dash-common:dash-common /home/dash-common/.dashcore/blocks/

for f in $files;do sudo ln -vs "../../../dash-common/.dashcore/blocks/$(basename $f)" "$f";done
sudo chown -Rv $dash1:$dash1 /home/$dash1/.dashcore/blocks/

for i in `seq 2 $num_nodes`;do
	sudo rm /tmp/[do][an][si][ho]*[ok][ne][fy]
	sudo bash -c "cp -v /home/$dashx$i/.dashcore/[do][an][si][ho]*[ok][ne][fy] /tmp/" &&\
	{ sudo rm -fr /home/$dashx$i/.dashcore/
	sudo cp -va /home/$dash1/.dashcore /home/$dashx$i
	sudo bash -c "rm -fr /home/$dashx$i/.dashcore/{.lock,.walletlock,d*.log,*.dat,onion*key} /home/$dashx$i/.dashcore/backups/"
	sudo cp -v /tmp/[do][an][si][ho]*[ok][ne][fy] /home/$dashx$i/.dashcore/
	sudo chown -v -R $dashx$i:$dashx$i /home/$dashx$i/;}
	sudo systemctl start dashd0$i
done
sudo systemctl start dashd01
