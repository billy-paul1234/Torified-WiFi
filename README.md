# 🌐 Torified-WiFi Access Point
- **Turn your Linux machine into a secure, Tor-routed WiFi access point!**  
- This script sets up a wireless AP that routes all traffic through Tor for anonymity.  


## 📂 Project Structure
```
📁 Torified-WiFi/ 
	├── 📜 ap0.conf # 🏗️ Hostapd configuration for AP 
	├── 🛠️ ap.sh # 🚀 Script to create the access point 
	├── 🔄 checkErrorAndChangeIP.sh # 🔍 Script to check and restart services 
	├── ❌ deleteAP.sh # ❌ Script to remove AP & reset firewall 
	├── 📜 dhcp.conf # 📡 DHCP server configuration 
	├── 🕵️ torrc # 🛑 Tor configuration 
	└── 📘 README.md # 📖 This file! 
	
```

---

## 🚀 Installation & Setup

### 🔹 1. Install Dependencies
Ensure you have the required packages installed:
```bash
sudo apt update
sudo apt install hostapd dnsmasq tor iptables
```

### 🔹 2. Clone the Repository
```bash
git clone https://github.com/billy-paul1234/Torified-WiFi.git
cd Torified-WiFi
```

### 🔹 3. Set Up the Access Point & Tor Routing
Run the setup script to configure the access point:
```bash
sudo bash ap.sh
```

### 🔹 5. Stopping the AP
To turn off the AP and reset settings, run:
```bash
sudo bash deleteAP.sh
```

---

## ⚙️ Configuration Details

### 📌 **Hostapd Configuration (`ap0.conf`)**
```ini
interface=ap0
driver=nl80211
hw_mode=g
channel=6
country_code=US
ssid=💀 AnonymousAP
wpa=2
wpa_passphrase=0987654321
rsn_pairwise=CCMP
```

### 📌 **Tor Configuration (`torrc`)**
```ini
VirtualAddrNetwork 10.192.0.0/10
AutomapHostsOnResolve 1
TransPort 9040
DNSPort 53
RunAsDaemon 1
ControlPort 9051
```

### 📌 **DHCP Configuration (`dhcp.conf`)**
```ini
interface=ap0
dhcp-range=192.168.40.100,192.168.40.200,255.255.255.0,12h
server=8.8.8.8
dhcp-option=3,192.168.40.1
```

---

## 🛡️ Security Considerations
✅ Uses **Tor** to anonymize traffic  
✅ **No logs** are stored  
✅ Uses **iptables** for firewall rules  
✅ Can be used as a **portable WiFi access point**  

---

## 📢 Credits
**Author:** `Billy Paul`<br>
**GitHub:** [billy-paul1234](https://github.com/billy-paul1234)  
🛠️ Open Source & Contributions Welcome!  

---

## 📌 Notes
- This script is intended for **ethical and privacy-conscious** usage.
- Use responsibly, as some networks may block Tor traffic.
- If you experience issues, check logs using:
  ```bash
  journalctl -u tor -f
  ``` 



