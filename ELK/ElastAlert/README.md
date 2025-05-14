ElastAlert File Structure: Required Files
```
elastalert/
├── config.yaml                 <-- 🔧 Main ElastAlert configuration
├── rules/                     <-- 📂 Folder containing alert rule files
│   └── <your_rule>.yaml       <-- 📜 Custom rule for alerting
├── elastalert.log             <-- 📄 Optional log file if logging is enabled
├── smtp_auth.yaml             <-- 🔐 Optional, for SMTP credentials (if separate)
├── elastalert_status (index)  <-- 🛢️ ES index used internally by ElastAlert
└── requirements.txt           <-- 📦 Python dependencies (if needed)
```
How They Work Together

```
[Filebeat] → [Elasticsearch] ← [ElastAlert] → [Rules] → [SMTP / Slack / Webhook]
                                     ↑
                            uses config.yaml

```


Great! Let’s go through a **simple and complete working ElastAlert setup** example step by step, so you can easily understand and replicate it.

---

## ✅ Goal of This Example:

We’ll create an alert that sends an **email** if **no logs are received** from a specific index (`filebeat-*`) in the **last 5 minutes** — this is useful to detect downtime or service issues.

---

## 🧱 Step-by-Step Setup

### 🗂 1. **Folder Structure**

Make sure your ElastAlert directory looks like this:

```bash
elastalert/
├── config.yaml
├── rules/
│   └── flatline_alert.yaml
```

---

### ⚙️ 2. **Main Config File: `config.yaml`**

```yaml
# config.yaml

es_host: localhost
es_port: 9200
writeback_index: elastalert_status

# Alert schedule
run_every:
  minutes: 1
buffer_time:
  minutes: 15

# SMTP settings for sending email
smtp_host: smtp.gmail.com
smtp_port: 587
smtp_ssl: true
from_addr: dkprojexts121@gmail.com
smtp_user: dkprojexts121@gmail.com
smtp_password: vllsxdhbxcwfprbm

# Directory with rules
rules_folder: rules

# Logging
verbose: true
```

---

### 📜 3. **Rule File: `rules/flatline_alert.yaml`**

```yaml
# rules/flatline_alert.yaml

name: "No logs in 5 minutes"
type: flatline

index: filebeat-*
threshold: 1

timeframe:
  minutes: 5

filter:
  - term:
      app: my_app  # replace with your actual field if needed

alert:
  - email

email:
  - your_email@example.com
```

🔁 **What it does:**

* Checks for logs with `app: my_app` in `filebeat-*` index.
* If it sees **no logs in the last 5 minutes**, it sends an email.

---

### 🚀 4. **Run ElastAlert**

From inside the `elastalert` directory, run:

```bash
python3 -m elastalert.elastalert --verbose --config config.yaml
```

If everything is configured correctly:

* ElastAlert connects to Elasticsearch
* Loads the rule
* Waits and checks every minute
* Sends an email if the rule triggers

---

### 🔎 5. **Verify:**

* Ensure your Elasticsearch is running and `filebeat-*` has data
* Check for logs in `elastalert_status` index in Kibana
* Watch for emails from `dkprojexts121@gmail.com`


## Steps



I'll guide you through setting up a complete log monitoring system with ElastAlert 2 on your dedicated EA node to monitor logs in your ELK production node. Here's a step-by-step walkthrough:

### 1. Initial Setup on EA Node (Ubuntu 22.04)

```bash
# Install dependencies
sudo apt update && sudo apt install -y python3-pip python3-dev libssl-dev

# Install ElastAlert 2
sudo pip3 install elastalert2

# Create configuration directory
sudo mkdir -p /etc/elastalert/{rules,config}
```

### 2. Base Configuration (`/etc/elastalert/config/config.yaml`)

```yaml
rules_folder: /etc/elastalert/rules
run_every:
  minutes: 1
buffer_time:
  minutes: 15
es_host: "your_elk_node_ip"  # Replace with ELK node IP
es_port: 9200
writeback_index: elastalert_status
alert_time_limit:
  days: 2
```

### 3. SMTP Configuration (`/etc/elastalert/config/smtp_auth.yaml`)

```yaml
user: "dkprojects121@gmail.com"
password: "your_app_password"  # Generate at: https://myaccount.google.com/apppasswords
```

### 4. Create Your First Alert Rule (`/etc/elastalert/rules/filebeat_alert.yaml`)

```yaml
name: "Filebeat Log Monitoring"
type: "flatline"
index: "filebeat-7.17.28-*"  # Match your exact Filebeat index pattern
threshold: 1
timeframe:
  minutes: 15

alert:
- "email"

email:
- "dineshkumar.s@e2enetworks.com"
smtp_host: "smtp.gmail.com"
smtp_port: 587
smtp_ssl: true
smtp_auth_file: "/etc/elastalert/config/smtp_auth.yaml"
from_addr: "dkprojects121@gmail.com"

alert_subject: "CRITICAL: Log flow stopped to {index}"
alert_text: |
  🚨 Log ingestion failure detected!
  
  ========================
  SYSTEM DETAILS
  ========================
  • ELK Node: {es_host}:9200
  • Index: {index}
  • Time since last log: 15 minutes
  • Expected rate: ~{avg_hits} logs/15min
  
  ========================
  IMMEDIATE ACTIONS
  ========================
  1. Check Filebeat: `systemctl status filebeat`
  2. Verify logs: `journalctl -u filebeat -n 50`
  3. Test connection: `curl -XGET '{es_host}:9200/_cluster/health?pretty'`

alert_text_type: alert_text_only
alert_text_kw:
  es_host: "{es_host}"
  index: "{index}"
  avg_hits: "{avg_hits}"

realert:
  minutes: 1440  # 24 hours between alerts
```

### 5. Initialize ElastAlert

```bash
# Create the writeback index
elastalert-create-index --config /etc/elastalert/config/config.yaml

# Test your rule
elastalert-test-rule --config /etc/elastalert/config/config.yaml /etc/elastalert/rules/filebeat_alert.yaml
```

### 6. Set Up as a Service

```bash
sudo nano /etc/systemd/system/elastalert.service
```

```ini
[Unit]
Description=ElastAlert
After=network.target

[Service]
User=root
WorkingDirectory=/etc/elastalert
ExecStart=/usr/local/bin/elastalert --config /etc/elastalert/config/config.yaml --verbose
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable elastalert
sudo systemctl start elastalert
```

### Verification Steps

1. **Check service status**:
```bash
sudo systemctl status elastalert
```

2. **View logs**:
```bash
journalctl -u elastalert -f
```

3. **Force a test alert**:
```bash
# Temporarily modify threshold
sudo sed -i 's/threshold: 1/threshold: 0/' /etc/elastalert/rules/filebeat_alert.yaml
sudo systemctl restart elastalert
```

### Key Points to Remember:

1. **Index Pattern Verification**:
```bash
# On ELK node
curl -XGET "http://localhost:9200/_cat/indices/filebeat-*?v"
```

2. **Firewall Rules**:
   - Ensure EA node can access ELK node on port 9200
   ```bash
   sudo ufw allow from ea_node_ip to elk_node_ip port 9200
   ```

3. **Gmail Setup**:
   - Use App Password (not regular password)
   - Enable "Less secure app access" if needed

This setup will:
- Monitor your Filebeat indices continuously
- Send alerts when log flow stops
- Prevent alert spam with 24-hour cooldown
- Provide actionable troubleshooting steps
- Run as a reliable system service
