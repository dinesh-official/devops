Perfect 👍 I’ll format this into a **README.md** file with clear sections for **ntopng installation + ClickHouse integration** on **Rocky Linux**.

Here’s the cleaned and well-structured version ⬇️

---

# 📘 ntopng Installation & ClickHouse Integration on Rocky Linux

This guide explains how to install **ntopng** and integrate it with **ClickHouse** for network flow storage and analysis on Rocky Linux.

---

## 🟦 Part 1: ntopng Installation & ClickHouse Integration

### 1. Add ntop Repository

```bash
curl https://packages.ntop.org/centos-stable/ntop.repo -o /etc/yum.repos.d/ntop.repo
```

### 2. Enable CRB Repository

```bash
dnf config-manager --set-enabled crb
```

### 3. Install EPEL Repository

```bash
dnf install epel-release -y
```

### 4. Install ntopng

```bash
dnf install ntopng -y
```

### 5. Enable ntopng at Boot

```bash
systemctl enable ntopng
```

### 6. Start ntopng Service

```bash
systemctl start ntopng
```

### 7. Check Service Status

```bash
systemctl status ntopng
```

✅ Ensure it shows **active (running)**.

---

### 8. Configure ntopng

Edit configuration file:

```bash
nano /etc/ntopng/ntopng.conf
```

Example configuration with ClickHouse integration:

```ini
# Export flows to ClickHouse
-F "clickhouse;127.0.0.1@9000;ntopng;default;MyStrongPassword"
```

**Parameters explained:**

* `clickhouse` → Export method
* `127.0.0.1@9000` → ClickHouse server address/port (change if remote)
* `ntopng` → Database name in ClickHouse
* `default` → ClickHouse username
* `MyStrongPassword` → ClickHouse user password

---

### 9. Restart ntopng

```bash
systemctl restart ntopng
```

### 10. Verify Service

```bash
systemctl status ntopng
```

### ✅ Access ntopng Web Interface

Open in browser:

```
http://<server-ip>:3000
```

Default login:

* **Username:** `admin`
* **Password:** `admin` (you will be prompted to change it)

---

## 🟦 Part 2: ClickHouse Installation & Remote Access

### 1. Install Required Packages

```bash
sudo yum install -y yum-utils curl ca-certificates gnupg2
```

### 2. Add ClickHouse Repository

```bash
sudo yum-config-manager --add-repo https://packages.clickhouse.com/rpm/clickhouse.repo
```

### 3. Install ClickHouse Server & Client

```bash
sudo yum install -y clickhouse-server clickhouse-client
```

### 4. Enable & Start ClickHouse

```bash
sudo systemctl enable clickhouse-server
sudo systemctl start clickhouse-server
sudo systemctl status clickhouse-server
```

---

### 5. Configure ClickHouse for Remote Access

#### 5.1 Edit Config

```bash
sudo nano /etc/clickhouse-server/config.xml
```

Update:

```xml
<tcp_port>9000</tcp_port>
<http_port>8123</http_port>
<listen_host>0.0.0.0</listen_host>
```

⚠️ `0.0.0.0` allows connections from any IP. For better security, restrict to specific IPs.

---

#### 5.2 Configure Users

```bash
sudo nano /etc/clickhouse-server/users.xml
```

Example:

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

### 6. Restart ClickHouse

```bash
sudo systemctl restart clickhouse-server
sudo systemctl status clickhouse-server
```

---

### 7. Test Remote Access

From another machine:

```bash
clickhouse-client --host <CLICKHOUSE_SERVER_IP> --port 9000 --user default --password <your_secure_password>
```

---

✅ At this point:

* ntopng is running and exporting flows to ClickHouse.
* ClickHouse is configured for **remote access**.
* You can now query network flow data directly in ClickHouse.

---

Would you like me to also create a **single setup script** (ntopng + ClickHouse + config) so you can just run it on a fresh Rocky Linux server and everything gets installed + configured automatically?
