Since our goal is to:

✅ Store **all flow data**  
✅ Use **ClickHouse** as the backend  
✅ Do **historical analysis** (weeks/months)  
✅ Get **deep filtering, dashboards, and GUI drill-downs**

---

### ✅ Best Version for You: **ntopng Enterprise M**

**Why Enterprise M?**  
It is:
- **Designed** for ClickHouse integration  
- Supports **unlimited flow exports**  
- Includes **advanced historical data access**  
- Allows per-host/protocol/port **filtering** in GUI  
- Comes with **API access**, **custom dashboards**, and **automation hooks**

---

### 📦 Version Recommendation

| Component        | Recommended Version         |
|------------------|-----------------------------|
| **ntopng**       | **Enterprise M 6.2+**        |
| **nprobe**       | Latest (optional, if NetFlow/IPFIX) |
| **ClickHouse**   | **v22.2+ or v23.3 LTS**      |
| **OS**           | Ubuntu 22.04 LTS (stable)    |

✅ The version you mentioned:
> `ntopng Community v.6.2.250403 (Ubuntu 22.04.4)`  
is **ok** for testing, but **not production-suitable** for flow history via ClickHouse.

---

### 🔐 Licensing

You can request an **Enterprise M trial** here:  
➡️ [https://shop.ntop.org/](https://shop.ntop.org/)

After getting the license, drop it into:
```bash
/etc/ntopng.license
```

---

### 🧰 Would You Like a Full Setup Script?

I can prepare a complete:
- ntopng Enterprise M installation
- ClickHouse integration
- GUI configuration
- Flow export setup

Here's a **full setup script** to install and configure **ntopng Enterprise M v6.2+** with **ClickHouse** on **Ubuntu 22.04**, designed for **full flow data storage** and **long-term historical visibility**.

---

### ✅ Prerequisites
- Clean Ubuntu 22.04
- Static IP & sudo/root access
- ntopng Enterprise M license
- ClickHouse installed and running
- Port `9000` open for ClickHouse

---

### 🚀 Full Setup Script (Run as root or with `sudo -i`)
```bash
#!/bin/bash

echo "[Step 1] Installing dependencies..."
apt update && apt install -y gnupg apt-transport-https wget curl software-properties-common

echo "[Step 2] Adding ntop repo..."
wget https://packages.ntop.org/apt/ntop.key -O /etc/apt/trusted.gpg.d/ntop.gpg
echo "deb https://packages.ntop.org/apt-stable/22.04/ x64/" > /etc/apt/sources.list.d/ntop.list
echo "deb https://packages.ntop.org/apt-stable/22.04/ all/" >> /etc/apt/sources.list.d/ntop.list

echo "[Step 3] Installing ntopng and dependencies..."
apt update
apt install -y ntopng nprobe

echo "[Step 4] Verifying ClickHouse installation..."
if ! command -v clickhouse-client &> /dev/null; then
  echo "❌ ClickHouse not installed! Please install ClickHouse first."
  exit 1
fi

echo "[Step 5] Creating ntopng ClickHouse DB (optional)..."
clickhouse-client --query="CREATE DATABASE IF NOT EXISTS ntopng;"

echo "[Step 6] Configuring ntopng to use ClickHouse..."
cat <<EOF > /etc/ntopng/ntopng.conf
--interface=eth0
--clickhouse
--clickhouse-host=127.0.0.1
--clickhouse-port=9000
--clickhouse-db=ntopng
--clickhouse-user=default
--clickhouse-pwd=
--local-networks=192.168.0.0/16
--data-dir=/var/lib/ntopng
--disable-login
--daemon
EOF

echo "[Step 7] Restarting ntopng..."
systemctl enable ntopng
systemctl restart ntopng

echo "[✅ Completed] ntopng is now configured to store flows in ClickHouse."
echo "👉 Access ntopng at http://<your-ip>:3000"
```

---

### 📌 Notes:
- Replace `eth0` with your network interface.
- Add your `--clickhouse-pwd` if password is set.
- Change `--local-networks` to match your environment.
- Enable historical views under the **Flow Explorer** in the UI.
- Use ClickHouse queries for custom historical insights.

---

