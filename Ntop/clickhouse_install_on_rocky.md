
# ClickHouse Installation & Remote Access Configuration on Rocky Linux 8

## **1️⃣ Install Required Packages**

```bash
sudo yum install -y yum-utils curl ca-certificates gnupg2
```

---

## **2️⃣ Add ClickHouse Repository**

```bash
sudo yum-config-manager --add-repo https://packages.clickhouse.com/rpm/clickhouse.repo
```

---

## **3️⃣ Install ClickHouse Server and Client**

```bash
sudo yum install -y clickhouse-server clickhouse-client
```

---

## **4️⃣ Enable and Start ClickHouse Service**

```bash
sudo systemctl enable clickhouse-server
sudo systemctl start clickhouse-server
sudo systemctl status clickhouse-server
```

---

## **5️⃣ Configure ClickHouse for Remote Access**

### **5.1 Edit main config file**

```bash
sudo nano /etc/clickhouse-server/config.xml
```

Update the `<listen_host>` to allow remote connections:

```xml
<tcp_port>9000</tcp_port>
<http_port>8123</http_port>
<listen_host>0.0.0.0</listen_host>
```

> `0.0.0.0` allows connections from any IP.
> For security, replace with specific IPs if needed.

---

### **5.2 Configure Users for Remote Access**

```bash
sudo nano /etc/clickhouse-server/users.xml
```

Modify the default user or create a new one:

```xml
<users>
    <default>
        <password>your_secure_password</password>
        <networks>
            <ip>::/0</ip> <!-- allow all IPs -->
        </networks>
        <profile>default</profile>
        <quota>default</quota>
    </default>
</users>
```

---

## **6️⃣ Restart ClickHouse**

```bash
sudo systemctl restart clickhouse-server
sudo systemctl status clickhouse-server
```

---

## **7️⃣ Test Remote Access**

From a remote machine:

```bash
clickhouse-client --host <CLICKHOUSE_SERVER_IP> --port 9000 --user default --password <your_secure_password>
```

---

## **8️⃣ Security Recommendations**

* Restrict access to trusted IPs using firewall rules.
* Use strong passwords for all ClickHouse users.
* Consider enabling SSL/TLS for encrypted connections.

---

## **Commands History (Reference)**

```bash
sudo yum install -y yum-utils curl ca-certificates gnupg2
sudo yum-config-manager --add-repo https://packages.clickhouse.com/rpm/clickhouse.repo
sudo yum install -y clickhouse-server clickhouse-client
sudo systemctl enable clickhouse-server
sudo systemctl start clickhouse-server
sudo systemctl status clickhouse-server
nano /etc/clickhouse-server/config.xml
sudo nano /etc/clickhouse-server/users.xml
sudo systemctl restart clickhouse-server
sudo systemctl status clickhouse-server
```
