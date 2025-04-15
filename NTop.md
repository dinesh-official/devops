
### ✅ **Must-Have for ntopng Installation**
To Install NTop 
https://www.ntop.org/guides/ntopng/installation.html#installing-on-linux

---


- MariaDB or ClickHouse for storage

ClickHouse for storage
---------------------
sudo apt update
sudo apt install -y apt-transport-https ca-certificates dirmngr
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E0C56BD4
echo "deb https://packages.clickhouse.com/deb stable main" | sudo tee /etc/apt/sources.list.d/clickhouse.list
sudo apt update
sudo apt install -y clickhouse-server clickhouse-client
sudo service clickhouse-server start



