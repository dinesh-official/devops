# **Complete Step-by-Step Guide: Installing ElastAlert2 & Setting Up Alerts for Remote ELK Stack**

---

## **🔹 Prerequisites**
1. **A separate server/machine** (where ElastAlert2 will run)
2. **Access to your ELK stack** (IP: `164.52.192.157:9200`)
3. **Python 3.6+** (recommended: Python 3.8+)
4. **Basic terminal knowledge** (SSH, `vim/nano`, `sudo` access)
5. **Ubuntu 22.04**

---

## **🔹 Step 1: Install ElastAlert2 on a New Node**
*(This node will monitor your ELK stack remotely.)*

### **1.1 Install Python & Dependencies**
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3 python3-pip python3-venv git
```

### **1.2 Create a Virtual Environment**
```bash
mkdir elastalert && cd elastalert
python3 -m venv venv
source venv/bin/activate  # Activate virtual environment
```

### **1.3 Install ElastAlert2**
```bash
pip install elastalert2
```

### **1.4 Verify Installation**
```bash
elastalert-create-index --help
```
*(If no errors, installation is successful.)*

---

## **🔹 Step 2: Configure ElastAlert2 to Connect to Remote ELK Stack**
*(Your ELK is at `164.52.192.157:9200`)*

### **2.1 Create `config.yaml`**
```bash
nano config.yaml
```
Paste:
```yaml
rules_folder: rules
run_every:
  minutes: 1
buffer_time:
  minutes: 15
es_host: 164.52.192.157  # Your ELK IP
es_port: 9200
es_username: "elastic"    # Change if using a different user
es_password: "yourpassword"
writeback_index: elastalert_status  # Stores alert metadata
alert_time_limit:
  days: 2
```

### **2.2 Create the Writeback Index**
```bash
elastalert-create-index
```
*(This will create `elastalert_status` in your Elasticsearch.)*

---

## **🔹 Step 3: Create a Rule to Detect Log Stoppage**
### **3.1 Make a `rules` Directory**
```bash
mkdir rules
```

### **3.2 Create `log_stoppage_alert.yaml`**
```bash
nano rules/log_stoppage_alert.yaml
```
Paste:
```yaml
name: "PRODUCTION LOG STOPPAGE ALERT"
type: flatline
index: "filebeat-*"  # Change if using a different index
threshold: 1         # Alert if no logs for X minutes
timeframe:
  minutes: 5         # Time window to check

# Optional: Filter for specific logs
filter:
- query:
    query_string:
      query: "fields.env:production"  # Adjust based on your logs

alert:
- email
email:
- "your.email@example.com"  # Change to your email
smtp_host: "smtp.gmail.com" # Change to your SMTP server
smtp_port: 587
smtp_auth_file: /etc/elastalert/smtp_auth.yaml  # We'll create this next
from_addr: "alerts@yourdomain.com"
email_reply_to: "no-reply@yourdomain.com"

alert_subject: "🚨 ALERT: Logs Stopped for Production!"
alert_text: |
  ❌ No logs received in the last 5 minutes!
  
  🔍 Details:
  - Index: {0}
  - Last log time: {1}
  
  🚀 Action Required: Check Filebeat/Logstash/Elasticsearch.
alert_text_args:
- index
- "@timestamp"
```

### **3.3 Set Up SMTP Authentication**
```bash
sudo mkdir /etc/elastalert
sudo nano /etc/elastalert/smtp_auth.yaml
```
Paste:
```yaml
user: "your.email@gmail.com"  # SMTP username
password: "your-app-password" # Use an app password for Gmail
```

### **3.4 Test the Rule**
```bash
elastalert-test-rule rules/log_stoppage_alert.yaml
```
*(Check for errors.)*

---

## **🔹 Step 4: Run ElastAlert2**
### **4.1 Test in Debug Mode**
```bash
elastalert --verbose --config config.yaml
```
*(Check if it connects to Elasticsearch and monitors logs.)*

### **4.2 Run as a Background Service**
```bash
sudo nano /etc/systemd/system/elastalert.service
```
Paste:
```ini
[Unit]
Description=ElastAlert2
After=network.target

[Service]
User=youruser
WorkingDirectory=/home/youruser/elastalert
ExecStart=/home/youruser/elastalert/venv/bin/elastalert --config /home/youruser/elastalert/config.yaml

[Install]
WantedBy=multi-user.target
```

**Enable & Start:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable elastalert
sudo systemctl start elastalert
sudo systemctl status elastalert  # Check if running
```

---

## **🔹 Step 5: Verify Alerts in Kibana**
1. **Check `elastalert_status` index** in Kibana Dev Tools:
   ```json
   GET elastalert_status/_search
   ```
2. **Check emails** (if SMTP is configured correctly).

---

## **🔹 Troubleshooting**
| Issue | Solution |
|--------|-----------|
| **Cannot connect to Elasticsearch** | Check firewall (`ufw allow 9200`), credentials, and ES logs |
| **No alerts triggered** | Adjust `timeframe.minutes` or `threshold` |
| **SMTP errors** | Test SMTP with `curl` or `telnet` |
| **Rule not loading** | Run `elastalert-test-rule` for debugging |

---

## **🎉 Done!**
Now, if logs stop flowing for 5+ minutes, you’ll get an email alert. 🚀  

Would you like help with **Kibana Alerting** (native alerts) as an alternative? Let me know! 🛠️
