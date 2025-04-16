
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


