**How to setup a self-hosted “home Dash masternode” on a Raspberry Pi, even if your home IP address is dynamic 🥳**  

**⚠️ draft ⚠️**  

  

_**Benefits** : costs less than traditional VPS hosting, **more decentralization, full control, freedom**, and the immense pleasure to have a masternode on your desk !_  😃  

_**What you'll need** : a Raspberry Pi fully dedicated to your home masternode (see point 1 below). If your home IP address is dynamic, you'll need another home Linux server in order to monitor your home IP address (see point 8 below), and a Dash wallet with some Dashs or Duffs inside._  

_Recommended : connect both servers to a UPS ([uninterruptible power supply](https://en.wikipedia.org/wiki/Uninterruptible_power_supply)) to keep them running in the event of a brief power interruption​​​​​​​._  

  

1\. Buy a **Raspberry Pi** :

*   A Raspberry Pi 4 model B (min. RAM : 4 GB) should work for a standard masternode. However a Raspberry Pi 5 will be better, and 8 GB of RAM is recommended in order to get better performance and/or Platform support.  
    
*   Put a fast card of 128 GB inside your Pi, for instance a SanDisk or Samsung card. However 64 GB may be enough for a standard masternode.  
    

  

2\. Install **Raspberry Pi OS Lite (64-bit)** on your Pi, using Raspberry Pi Imager. You only need your usual computer, you don't need to connect a monitor, a mouse and a keyboard to your Pi (but you can if you wish). **Follow this guide for this headless installation :** [https://raspberrytips.com/raspberry-pi-headless-setup/](https://raspberrytips.com/raspberry-pi-headless-setup/)  

_Please note :_  

*   In the username creation form, call this user "**mno**".  
    
*   Do not configure wireless LAN (wifi).  
    

  

3\. Setup your Pi **behind a home router**, connect it to the router with an Ethernet cable. Follow your router's guide to :

*   configure the router to attribute a **fixed** local IP address to your Pi (for instance : 192.168.0.100) ;  
    
*   **redirect** the home router's external port 9999 to Pi's internal port 9999.  
    

  

4\. **Start your Pi** and connect to it as the **mno** user :

*   use an external monitor connected to your Pi,  
    
*   or (simpler) connect through SSH from your usual computer (for instance, Terminal app on macOS) : **ssh mno@**_\[your Pi's local IP address\]_  
    

  

5\. **Install Dash Masternode Zeus** (DMZ) on your Pi :

*   sudo apt install git  
    
*   git clone https://github.com/kxcd/Masternode-Zeus
*   chmod +x Masternode-Zeus/masternode\_zeus.sh

  

6\. **Run Dash Masternode Zeus** on your Pi :  

*   Masternode-Zeus/masternode\_zeus.sh  
    
*   Ask it to install Dash Core : “**1\. Install and configure a new DASH Masternode**” in the main menu.  
    
*   DMZ will ask you to reboot the Pi. Then connect to it again, re-launch DMZ and select the “Install and configure a new DASH Masternode” again, in order to finish the MN installation.  
    
*   Then go to “**2\. Check system status**” to check the blocks coming in (will take a few hours to download all blocks — wait before following the step 7 below).  
    

  

7\. **Register your MN on the Dash blockchain** :

*   Open the console of your Dash Core wallet on your personal computer. Be sure it contains at least some Duffs, in order to pay the registration transaction below.  
    
*   Open the Dash Core console and enter the following command : …………  
    

  

8\. **(_OPTIONAL_)** **Does your ISP only provide you a** **_dynamic_ IP address, instead of a stable one ?** Then your self-hosted MN might be ejected from the payment queue. You'll need to have **another home server** to monitor possible IP changes, and auto-register on the Dash blockchain those changes, in order to keep the MN fully enabled and in the payment queue.  

The following example uses a Ubuntu 20.04 server :  

*   **Install Dash Core** on this server (in case it's not already there), and feed it with a few Dashs or even duffs (0.00010000 Dash, i.e. 10000 Duffs, should be enough for many IP change transactions) :  
    
*   To install Dash Core, follow these instructions : [https://docs.dash.org/en/stable/docs/user/wallets/dashcore/installation-linux.html](https://docs.dash.org/en/stable/docs/user/wallets/dashcore/installation-linux.html) \[_unfortunately, this is not a command line guide !_\]  
    
*   To generate the address where you will send your Duffs, use this command :  
    /opt/dash/bin/dash-cli getnewaddress  
    
*   From another Dash wallet, send 0.00010000 Dash to the newly generated address.  
    
*   On your server, verify the received Duffs using this command :  
    /opt/dash/bin/dash-cli listunspent  
    
*   **Install masternode\_ip script** in ~/bin/ on your server :  
    
*   wget …………………………………/masternode\_ip.sh  
    
*   Edit the script (nano ~/bin/masternode\_ip.sh) and replace the two values PROTX and BLS\_PRIV\_KEY at the beginning of the script with your MN's values, then replace the FEE\_SOURCE\_ADDRESS value with the newly generated address above.  
    
*   Make the script executable :  
    chmod +x ~/bin/masternode\_ip.sh   
    
*   Test the script :  
    ~/bin/masternode\_ip.sh   
    
*   Did it return a success message ? Then configure cron on your server in order to run the script every hour : crontab -e, then add this line to your crontab :  
    0 \* \* \* \* ~/bin/masternode\_ip.sh > ~/bin/masternode\_ip.log 2>&1