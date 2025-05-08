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
