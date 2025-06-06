
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
```
# Add repository
sudo apt-get install -y apt-transport-https ca-certificates dirmngr
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E0C56BD4
echo "deb https://packages.clickhouse.com/deb stable main" | sudo tee /etc/apt/sources.list.d/clickhouse.list
sudo apt-get update

# Install
sudo apt-get install -y clickhouse-server clickhouse-client

# Start service
sudo systemctl enable --now clickhouse-server
```


Database Schema for the ntop (ntopng Enterprise XL v.6.2.250403)

```
CREATE DATABASE IF NOT EXISTS ntopng;

USE ntopng;

CREATE TABLE IF NOT EXISTS flows (
    first_seen DateTime64(3) CODEC(DoubleDelta, LZ4),
    last_seen DateTime64(3) CODEC(DoubleDelta, LZ4),
    client_ip IPv6,
    server_ip IPv6,
    client_port UInt16 CODEC(T64, LZ4),
    server_port UInt16 CODEC(T64, LZ4),
    protocol UInt8 CODEC(T64, LZ4),
    l7_proto UInt16 CODEC(T64, LZ4),
    l7_proto_name LowCardinality(String),
    bytes UInt64 CODEC(T64, LZ4),
    packets UInt32 CODEC(T64, LZ4),
    duration UInt32 CODEC(T64, LZ4),
    vlan_id UInt16 CODEC(T64, LZ4),
    tcp_flags UInt8 CODEC(T64, LZ4),
    client_country String,
    server_country String,
    info String CODEC(ZSTD(3))
ENGINE = MergeTree()
PARTITION BY toYYYYMMDD(first_seen)
ORDER BY (first_seen, client_ip, server_ip, l7_proto)
TTL first_seen + INTERVAL 30 DAY;

```



https://phoenixnap.com/kb/install-clickhouse-on-ubuntu



refer these
https://packages.ntop.org/apt-stable/
https://clickhouse.com/docs/install#install-from-deb-packages

```

ls
    2  sudo apt-get update
    3  sudo apt-get install software-properties-common wget gnupg lsb-release -y
    4  sudo apt-get upgrade
    5  sudo apt-get dist-upgrade
    6  sudo apt-get update
    7  sudo apt-get install software-properties-common wget gnupg lsb-release -y
    8  sudo add-apt-repository universe -y
    9  wget https://packages.ntop.org/apt-stable/22.04/all/apt-ntop-stable.deb
   10  sudo apt install ./apt-ntop-stable.deb -y
   11  sudo apt-get update
   12  sudo systemctl start ntopng
   13  sudo systemctl enable ntopng
   14  sudo apt install ntopng -y
   15  sudo systemctl start ntopng
   16  sudo systemctl status ntopng
   17  sudo apt-get install dirmngr
   18  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E0C56BD4
   19  echo "deb https://packages.clickhouse.com/deb stable main" | sudo tee /etc/apt/sources.list.d/clickhouse.list
   20  sudo apt-get update
   21  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 3E4AD4719DDE9A38
   22  sudo apt-get update
   23  sudo apt-get install clickhouse-server clickhouse-client
   24  sudo systemctl enable clickhouse-server
   25  sudo systemctl start clickhouse-server
   26  clickhouse-client
   27  sudo nano /etc/ntopng/ntopng.conf
   28  sudo systemctl restart ntopng
   29  sudo systemctl status ntopng
   30  clickhouse-client --query "SELECT count(*) FROM ntopng.flowsv6"
   31  clickhouse-client --user default --password 860835 --query "SELECT count(*) FROM ntopng.flowsv6"
   32  clickhouse-client --user default --password 860835 --query "SHOW TABLES FROM ntopng"
   33  sudo ntopng --version | grep -i clickhouse
   34  sudo ntopng --version
   35  history
```
