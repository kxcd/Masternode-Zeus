#!/bin/bash


PROG="$0"
MY_IP=

PROTX="enter here"
BLS_PRIV_KEY="enter here"
FEE_SOURCE_ADDRESS="enter here"

check_ip(){
	local new_ip
	local output
	# Get the IP for one of two sources.
	new_ip=$(curl -4s https://icanhazip.com/)||new_ip=$(curl -4s https://ipecho.net/plain)
	# Some simple validation the IP is likely valid.
	(( $? !=0 || ${#new_ip} < 7 || ${#new_ip} > 15 ))\
	&& { echo "Error fetching ip address, bailing out.";return;}
	if [[ "$MY_IP" != "$new_ip" ]];then
		if [[ -n $MY_IP ]];then
			echo "The Masternode's IP has changed from $MY_IP to $new_ip, sending protx to update it now..."
			output=$(/opt/dash/bin/dash-cli -conf=/home/dash/.dashcore/dash.conf protx update_service $PROTX "${new_ip}:9999" "$BLS_PRIV_KEY" "" "$FEE_SOURCE_ADDRESS" 2>&1)
			if (($?==0));then
				echo "The protx was successful here is the tx hash: $output."
			else
				echo "The protx has failed with error,"
				echo "$output"
			fi
		fi
		# Store the new IP in this file.
		sed -i "s/\(^MY_IP=\).*/\1$new_ip/" "$PROG"
	fi
}

check_ip
