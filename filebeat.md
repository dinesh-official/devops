# 🧠 What is Filebeat?
Filebeat is a lightweight log shipper by Elastic, designed to forward and centralize log data. It monitors log files (like `/var/log/nginx/access.log`), reads new entries, and ships them to Elasticsearch or Logstash for indexing and analysis.

---

## ✅ Step 1: Download and Install Filebeat 7.7.1
Since 7.7.1 is an older version, you need to download the `.deb` package manually.

### 1.1 Download Filebeat 7.7.1
```bash
cd /tmp
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.7.1-amd64.deb
```

### 1.2 Install the `.deb` package
```bash
sudo dpkg -i filebeat-7.7.1-amd64.deb
```

### 1.3 Enable Filebeat to start on boot
```bash
sudo systemctl enable filebeat
```

---

## ⚙️ Step 2: Configure Filebeat
Filebeat config is at `/etc/filebeat/filebeat.yml`.

### Open the configuration file:
```bash
sudo nano /etc/filebeat/filebeat.yml
```

### 2.1 Basic Input Configuration
For example, to collect Nginx logs:
```yaml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /var/log/nginx/access.log
      - /var/log/nginx/error.log
```

### 2.2 Set Elasticsearch Output (Skip Logstash for now)
```yaml
output.elasticsearch:
  hosts: ["http://localhost:9200"]
```

🔐 If Elasticsearch is secured, include:
```yaml
  username: "elastic"
  password: "yourpassword"
```

### 2.3 Optional: Enable Kibana (for dashboards)
```yaml
setup.kibana:
  host: "http://localhost:5601"
```

---

## 🎛️ Step 3: Enable Modules (e.g., nginx, system)
Filebeat comes with modules for common logs.

### To enable Nginx parsing:
```bash
sudo filebeat modules enable nginx
```

### For system logs:
```bash
sudo filebeat modules enable system
```

### Then edit the module config (optional):
```bash
sudo nano /etc/filebeat/modules.d/nginx.yml
```
Ensure the paths match your Nginx logs.

---

## 🚀 Step 4: Load Dashboards (Optional)
This sets up visualizations in Kibana:
```bash
sudo filebeat setup --dashboards
```

---

## ▶️ Step 5: Start Filebeat
```bash
sudo systemctl start filebeat
```

### Check logs:
```bash
sudo journalctl -u filebeat -f
```

---

## 🔍 Step 6: Verify in Elasticsearch
Check if Filebeat is pushing logs:
```bash
curl -XGET 'http://localhost:9200/_cat/indices?v'
```
Look for indices like:
```
filebeat-7.7.1-YYYY.MM.DD
```

Or search in Kibana’s Discover tab using:
```
filebeat-* index pattern
```

---

## 🔄 How Filebeat Works (Internally)
| Step | What Happens |
|------|---------------|
| 1️⃣ | Watches log files (access.log, error.log, etc.) |
| 2️⃣ | Reads new lines and parses them using modules or processors |
| 3️⃣ | Converts them into structured JSON documents |
| 4️⃣ | Sends them to Elasticsearch (or Logstash if configured) |
| 5️⃣ | Elasticsearch indexes them, and you can visualize in Kibana |

---

## 📦 Bonus: Enable Filebeat Service on Boot
```bash
sudo systemctl enable filebeat
```

---
