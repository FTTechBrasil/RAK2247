# RAK2247
<img src="https://docs.rakwireless.com/assets/images/wislink-lora/rak2247/quickstart/1.main/RAK2247_buy.png" width="200"/>

Script to shorten RAK2247 installation process.


# Local Configuration
- Log into your device, in this case a board running Raspberry OS Lite.
- Install git so you can clone the repository.
```sh
sudo apt-get install git
```
- Clone this rep.
```sh
git clone https://github.com/FTTechBrasil/RAK2247.git
```

- Go to the cloned rep and change the `.sh` files to executables.
```sh
chmod +x *.sh
```

- Run the installation script and wait for it to complete.
```sh
sudo ./install.sh
```

By the end of this script you should see a message with your gateway's EUID, like this:
```sh
 #################################################################

                  GATEWAY EUID = B724EBFFFE80F5D5

    Open TTN console and register your gateway using your EUI: 
         https://console.thethingsnetwork.org/gateways 

 #################################################################
```

If this message didn't show up, you can check it by running `./showeui.sh`

- Check if your package fowarder is running.
```sh
service ttn-gateway status
```

# The Things Network
After the installation you can go to [TTNs Console](https://console.thethingsnetwork.org/gateways) and register your gateway using the legacy package fowarder with the `GATEWAY EUID` that you found before.
