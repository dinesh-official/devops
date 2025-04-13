# 🧠 What is Filebeat?
Filebeat is a lightweight log shipper by Elastic, designed to forward and centralize log data. It monitors log files (like `/var/log/nginx/access.log`), reads new entries, and ships them to Elasticsearch or Logstash for indexing and analysis.

---

## ✅ Step 1: Download and Install Filebeat 7.7.1
Since 7.7.1 is an older version, you need to download the `.deb` package manually.

**Download Filebeat 7.7.1**:
```bash
cd /tmp
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.7.1-amd64.deb
```

**Install the `.deb` package**:
```bash
sudo dpkg -i filebeat-7.7.1-amd64.deb
```

**Enable Filebeat to start on boot**:
```bash
sudo systemctl enable filebeat
```

If you want to install Filebeat using `sudo apt install filebeat` instead of manually downloading and installing the `.deb` package, you can follow these steps to set up the Elastic APT repository and install Filebeat directly using APT:

### Step-by-Step Instructions:

1. **Add the Elastic APT repository**:
   First, you'll need to add the Elastic APT repository to your system.

   ```bash
   wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
   ```

2. **Install the APT transport HTTPS package** (if not already installed):
   This will allow APT to access repositories over HTTPS.

   ```bash
   sudo apt-get install apt-transport-https
   ```

3. **Add the Elastic repository to your APT sources list**:

   ```bash
   echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
   ```

4. **Update your APT package index**:

   ```bash
   sudo apt-get update
   ```

5. **Install Filebeat** using APT:

   ```bash
   sudo apt-get install filebeat
   ```

This way, you can install Filebeat with the convenience of the `sudo apt install` command rather than manually downloading the `.deb` package.

---

## ⚙️ Step 2: Configure Filebeat
Filebeat config is at `/etc/filebeat/filebeat.yml`.

**Open the configuration file:**
```bash
sudo nano /etc/filebeat/filebeat.yml
```

**Basic Input Configuration**
For example, to collect Nginx logs:
```yaml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /var/log/nginx/access.log
      - /var/log/nginx/error.log
```

**Set Elasticsearch Output (Skip Logstash for now)**
```yaml
output.elasticsearch:
  hosts: ["http://localhost:9200"]
```

**🔐 If Elasticsearch is secured, include:**
```yaml
  username: "elastic"
  password: "yourpassword"
```

**Optional: Enable Kibana (for dashboards)**
```yaml
setup.kibana:
  host: "http://localhost:5601"
```

---

## 🎛️ Step 3: Enable Modules (e.g., nginx, system)
Filebeat comes with modules for common logs.

**To enable Nginx parsing:**
```bash
sudo filebeat modules enable nginx
```

**For system logs:**
```bash
sudo filebeat modules enable system
```

**Then edit the module config (optional):**
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

**Check logs:**
```bash
sudo journalctl -u filebeat -f
```

---

## 🔍 Step 6: Verify in Elasticsearch
**Check if Filebeat is pushing logs:**
```bash
curl -XGET 'http://localhost:9200/_cat/indices?v'
```
**Look for indices like:**
```
filebeat-7.7.1-YYYY.MM.DD
```

**Or search in Kibana’s Discover tab using:**
```
filebeat-* index pattern
```


**Enable Filebeat Service on Boot**
```bash
sudo systemctl enable filebeat
```

---


# Filebeat Workflow Architecture

Here's a simplified version of the Filebeat workflow in a text-based architecture diagram:

```
+-------------------+
| 1️⃣ Watch log files|
+-------------------+
         ↓
+-------------------+
| 2️⃣ Read & Parse   |
+-------------------+
         ↓
+-------------------+
| 3️⃣ Convert to JSON|
+-------------------+
         ↓
+-------------------+
| 4️⃣ Send to Elastic|
+-------------------+
         ↓
+---------------------+
| 5️⃣ Index & Visualize|
+---------------------+
```


---

 **📦 Bonus: Enable Filebeat Service on Boot**
```bash
sudo systemctl enable filebeat
```

---

## 🔄 Filebeat Output Types Explained

Filebeat supports multiple output types. Each type sends the processed log data to a different backend or service.
```
+-------------------------+    +-----------------------+    +-----------------------+    +-----------------------+
| 1️⃣ Elasticsearch Output | →  | 2️⃣ Logstash Output    | →  | 3️⃣ Kafka Output       | →  | 4️⃣ Redis Output       |
+-------------------------+    +-----------------------+    +-----------------------+    +-----------------------+
           ↓                           ↓                         
+-------------------------+    +-----------------------+    
| 5️⃣ Console Output       | →  | 6️⃣ File Output        |
+-------------------------+    +-----------------------+
```

### ✅ 1. Elasticsearch Output
Most commonly used with the Elastic Stack.
```yaml
output.elasticsearch:
  hosts: ["http://localhost:9200"]
  username: "elastic"
  password: "yourpassword"
```

**Use when:**
- You want to index logs directly in Elasticsearch.
- You plan to visualize logs in Kibana.

### 🛠️ 2. Logstash Output
Use this if you want to process logs using Logstash before indexing into Elasticsearch.
```yaml
output.logstash:
  hosts: ["localhost:5044"]
```

**Use when:**
- You need complex parsing or filtering.
- You want to buffer or route logs before Elasticsearch.

### 💬 3. Kafka Output
Useful for sending logs to Apache Kafka for distributed processing.
```yaml
output.kafka:
  hosts: ["kafka-broker1:9092"]
  topic: "logs"
```

**Use when:**
- You're working in a microservices environment.
- You need log streaming or queuing.

### 🔗 4. Redis Output
Sends logs to Redis queues.
```yaml
output.redis:
  hosts: ["localhost"]
  key: "filebeat"
```

**Use when:**
- You want to temporarily store logs in memory.
- You're building custom log consumers.

### 📬 5. Console Output (for testing/debug)
Prints logs to the terminal instead of sending them anywhere.
```yaml
output.console:
  pretty: true
```

**Use when:**
- You're debugging your configuration.
- You want to see output locally.

### 📁 6. File Output
Writes logs to a local file.
```yaml
output.file:
  path: "/tmp/filebeat"
  filename: "filebeat"
```

**Use when:**
- You're testing or archiving logs.
- You want a local copy of the structured logs.

---

## 📤 Switching Outputs

You can only use one output at a time in `filebeat.yml`. So, make sure to comment out all others:

```yaml
# output.elasticsearch:
#   hosts: ["http://localhost:9200"]

output.logstash:
  hosts: ["localhost:5044"]
```

---

## 📘 Reference: All Output Types

| Output Type     | Description                                     |
|-----------------|-------------------------------------------------|
| **elasticsearch** | Default for Elastic Stack                      |
| **logstash**      | For complex pipelines & filtering              |
| **kafka**         | For message queue-based architectures          |
| **redis**         | Lightweight in-memory buffering                |
| **console**       | For debugging/log viewing locally              |
| **file**          | For saving logs to disk                        |

---

## 📦 Example: Switching from Elasticsearch to Logstash

Before (default):
```yaml
output.elasticsearch:
  hosts: ["http://localhost:9200"]
```

After (with Logstash):
```yaml
# output.elasticsearch:
#   hosts: ["http://localhost:9200"]

output.logstash:
  hosts: ["localhost:5044"]
```

```


# output.elasticsearch:
#   hosts: ["http://localhost:9200"]

output.logstash:
  hosts: ["localhost:5044"]
Would you like a GitHub README or config file showing each output as a switchable config block? I can prepare that for you too.
