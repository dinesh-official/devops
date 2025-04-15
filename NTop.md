
### ✅ **Must-Have for ntopng Installation**
To Install NTop 
https://www.ntop.org/guides/ntopng/installation.html#installing-on-linux

---
commands :
```
sudo apt-get update
sudo apt-get install software-properties-common wget gnupg lsb-release -y
sudo add-apt-repository universe -y

wget https://packages.ntop.org/apt-stable/22.04/all/apt-ntop-stable.deb
sudo apt install ./apt-ntop-stable.deb -y

sudo apt update
sudo apt install ntopng -y

sudo systemctl enable ntopng
sudo systemctl start ntopng
```


- MariaDB or ClickHouse for storage

ClickHouse for storage
---------------------
# Add repository
sudo apt-get install -y apt-transport-https ca-certificates dirmngr
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E0C56BD4
echo "deb https://packages.clickhouse.com/deb stable main" | sudo tee /etc/apt/sources.list.d/clickhouse.list
sudo apt-get update

# Install
sudo apt-get install -y clickhouse-server clickhouse-client

# Start service
sudo systemctl enable --now clickhouse-server


https://phoenixnap.com/kb/install-clickhouse-on-ubuntu


