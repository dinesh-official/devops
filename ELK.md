**Text-based architecture** of how the ELK stack works:

```
+-----------------+        +----------------+        +---------------------+
|  Filebeat       |  --->  |   Logstash     |  --->  |   Elasticsearch     |
|  (Log Collector)|        | (Data Processor|        | (Data Storage &     |
|                 |        |   and Filter)  |        |  Search Engine)     |
+-----------------+        +----------------+        +---------------------+
        |                        |                          |
        |                        |                          |
        v                        v                          v
   +-----------------+   +-------------------+        +-------------------+
   | Local System    |   | Logstash Pipeline  |        | Elasticsearch     |
   | (Logs generated)|   | (Data transformation|        | Indexes & Storage |
   |                 |   | and enrichment)    |        |                   |
   +-----------------+   +-------------------+        +-------------------+
                                                                 |
                                                                 v
                                                    +---------------------+
                                                    |       Kibana         |
                                                    | (Visualize & Query   |
                                                    |   Data in Elasticsearch)|
                                                    +---------------------+
```

### Step-by-step flow:
1. **Filebeat**: Collects logs from local systems and forwards them to **Logstash**.
2. **Logstash**: Processes and filters the logs. It can parse, transform, and enrich data.
3. **Elasticsearch**: Stores the logs and indexes them, making it easier to search and analyze.
4. **Kibana**: Visualizes the data stored in **Elasticsearch** and provides a user-friendly interface to query and analyze the logs.

---

## ✅ RECOMMENDED STABLE ELK VERSIONS (As of April 2025)

| Component      | Version       | Reason                                  |
|----------------|---------------|------------------------------------------|
| **Elasticsearch** | `7.17.16`      | LTS, stable, no forced SSL/security      |
| **Kibana**        | `7.17.16`      | Matches Elasticsearch 7.17               |
| **Logstash**      | `7.17.16`      | Fully compatible with the above          |

This combo avoids SSL & user auth headaches while still being robust for production or learning.



---

## 🔁 STEP-BY-STEP INSTALLATION (Stable ELK 7.17.16 on Ubuntu 22.04)

### 🔹 Add Elastic GPG Key & 7.x Repo

```bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update
```

---

## 📦 INSTALL ELASTICSEARCH

```bash
sudo apt install -y elasticsearch=7.17.16
```

Edit config:
```bash
sudo nano /etc/elasticsearch/elasticsearch.yml
```

Add:
```yaml
cluster.name: elk-cluster
node.name: elk-node
network.host: 0.0.0.0
http.port: 9200
discovery.type: single-node
```

Start:
```bash
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch
```

Test:
```bash
curl http://localhost:9200
```

---

## 📦 INSTALL KIBANA

```bash
sudo apt install -y kibana=7.17.16
```

Edit config:
```bash
sudo nano /etc/kibana/kibana.yml
```

Add:
```yaml
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://localhost:9200"]
```

Start:
```bash
sudo systemctl enable kibana
sudo systemctl start kibana
```

Access:
```
http://<your-ip>:5601
```

---

## 📦 INSTALL LOGSTASH

```bash
sudo apt install -y logstash=1:7.17.16-1
```

Create a test config:
```bash
sudo nano /etc/logstash/conf.d/test.conf
```

Paste:
```conf
input { stdin {} }
output { stdout { codec => rubydebug } }
```

Test:
```bash
echo "hello" | sudo /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/test.conf
```

Then:
```bash
sudo systemctl enable logstash
sudo systemctl start logstash
```

---

Great! Now let’s move on to **getting logs and sending them to Logstash**.

We’ll use **Filebeat** to forward logs to Logstash, as it’s the most common and lightweight method for sending logs from your system to Logstash for further processing.

### 📝 **Steps for Sending Logs to Logstash using Filebeat**

---

### 🔹 **Step 1: Install Filebeat on Your Ubuntu Server**

1. **Install Filebeat**
   ```bash
   sudo apt install -y filebeat=7.17.16
   ```

---

### 🔹 **Step 2: Configure Filebeat to Forward Logs to Logstash**

1. **Edit Filebeat Config to Use Logstash Output**
   ```bash
   sudo nano /etc/filebeat/filebeat.yml
   ```

2. **Configure Filebeat to Send Logs to Logstash**
   - Look for the `output.logstash` section and uncomment it:
     ```yaml
     output.logstash:
       # The Logstash hosts
       hosts: ["localhost:5044"]
     ```

3. **Configure Logstash Input**
   In **Logstash**, we need to create an input for Filebeat:

   ```bash
   sudo nano /etc/logstash/conf.d/filebeat-input.conf
   ```

   Add the following:
   ```conf
   input {
     beats {
       port => 5044
     }
   }

   output {
     elasticsearch {
       hosts => ["http://localhost:9200"]
       index => "filebeat-%{+YYYY.MM.dd}"
     }
     stdout { codec => rubydebug }
   }
   ```

---

### 🔹 **Step 3: Start Filebeat and Logstash**

1. **Enable and Start Filebeat**
   ```bash
   sudo systemctl enable filebeat
   sudo systemctl start filebeat
   ```

2. **Enable and Start Logstash**
   ```bash
   sudo systemctl enable logstash
   sudo systemctl start logstash
   ```

---

### 🔹 **Step 4: Test Log Forwarding**

To test if Filebeat is sending logs to Logstash:

1. **Check Filebeat Status**
   ```bash
   sudo systemctl status filebeat
   ```

2. **Check Logstash Status**
   ```bash
   sudo systemctl status logstash
   ```

3. **Check Logstash Logs for Incoming Data**
   ```bash
   sudo journalctl -u logstash -f
   ```

4. **Check Elasticsearch Index**
   Visit Kibana’s **Discover** tab and check for logs under the `filebeat-*` index pattern.

---

### 🔹 **Step 5: Verify Data in Kibana**

1. Open Kibana at `http://<your-ip>:5601`
2. Go to **Discover** → Select the index pattern you created earlier (`filebeat-*`)
3. You should now see logs flowing into Elasticsearch!

---

If everything is set up, you should start seeing logs in **Kibana** and **Logstash**. Let me know if you run into any issues or errors!

## 🎯 Final Step: Create Kibana Index Pattern

1. Visit Kibana at `http://<IP>:5601`
2. Go to **Stack Management → Index Patterns**
3. Add: `logstash-*` or `syslog-*` as index pattern
4. Choose `@timestamp` as time field

---

✅ **Stable ELK 7.17.16 should now work flawlessly without SSL or auth headaches.**

Let me know if you want me to script the whole install or troubleshoot an error you're seeing.
