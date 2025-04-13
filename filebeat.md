# 🧠 What is Filebeat?
Filebeat is a lightweight log shipper by Elastic, designed to forward and centralize log data. It monitors log files (like `/var/log/nginx/access.log`), reads new entries, and ships them to Elasticsearch or Logstash for indexing and analysis.

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

 **📦 Optional: Enable Filebeat Service on Boot**
```bash
sudo systemctl enable filebeat
```
# 📄 Filebeat Configuration Architecture

Here’s a **simplified and easy-to-understand text-based architecture** for how Filebeat configuration works:

```
                   +----------------------+
                   |    Log Files         |
                   |  (e.g., access.log)  |
                   +----------+-----------+
                              |
                              v
                  +------------------------+
                  | filebeat.inputs        |
                  | (What to read?)        |
                  +----------+-------------+
                              |
                              v
         +----------------------------------------+
         | filebeat.modules (Optional Templates)  |
         | (e.g., nginx, apache, system logs)     |
         +----------------+-----------------------+
                              |
                              v
                   +----------------------+
                   |   Processors         |
                   | (Add/Remove fields,  |
                   |  enrich log data)    |
                   +----------+-----------+
                              |
                              v
        +------------------------------------------+
        | Outputs (Choose One)                     |
        | - Elasticsearch                          |
        | - Logstash                               |
        | - Kafka                                  |
        | - Redis                                  |
        | - File / Console                         |
        +----------------+-------------------------+
                              |
                              v
               +-----------------------------+
               | Final Destination / Kibana  |
               | (Search, Analyze, Visualize)|
               +-----------------------------+
```

### 💡 Key Concepts:

- **Inputs** → What logs Filebeat reads.
- **Modules** → Prebuilt configs for common services.
- **Processors** → Clean or enrich logs.
- **Output** → Where logs are sent.
- **Kibana** → View and analyze the logs.

-

 Here's a **clear and structured breakdown** of the **input types** and **output types** in Filebeat, along with how to configure them in `filebeat.yml`: 

-

## 📝 Filebeat Input Types 

These define **where Filebeat reads data from**



### ✅ Common Input Types:

| Input Type | Description |
|------------|-------------|
| `log` | Reads log files line by line (most common use) |
| `stdin` | Reads from standard input (e.g., for testing) |
| `container` | Collects logs from container log files |
| `docker` | Collects logs from Docker JSON logs |
| `kafka` | Reads messages from a Kafka topic |
| `http_endpoint` | Accepts logs via HTTP POST (experimental) |

### 🧾 Example Configuration:

```yaml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /var/log/syslog
      - /var/log/auth.log
```

For container logs:

```yaml
filebeat.inputs:
  - type: container
    paths:
      - /var/lib/docker/containers/*/*.log
```

---

## 🚀 Filebeat Output Types 

These define **where Filebeat sends data** after collecting and processing it.

### ✅ Supported Output Types:

| Output Type | Description |
|-------------|-------------|
| `elasticsearch` | Sends logs directly to Elasticsearch |
| `logstash` | Sends logs to Logstash for further processing |
| `kafka` | Publishes logs to Kafka topics |
| `redis` | Sends logs to Redis queues |
| `file` | Writes logs to a file on disk |
| `console` | Prints logs to the console (useful for debugging) |
| `cloud` | Sends logs to Elastic Cloud |
| `opensearch` | Sends logs to an OpenSearch cluster |

---

### 📦 Output Configuration Examples:

#### Elasticsearch Output:

```yaml
output.elasticsearch:
  hosts: ["http://localhost:9200"]
```

#### Logstash Output:

```yaml
output.logstash:
  hosts: ["localhost:5044"]
```

#### Kafka Output:

```yaml
output.kafka:
  hosts: ["localhost:9092"]
  topic: "filebeat"
```

#### Redis Output:

```yaml
output.redis:
  hosts: ["localhost"]
  key: "filebeat"
```

#### File Output (for local file storage):

```yaml
output.file:
  path: "/tmp/filebeat"
  filename: "output.log"
```

#### Console Output (for testing/debugging):

```yaml
output.console:
  pretty: true
```


### 🧠 Tip:

Only **one output** can be active at a time in Filebeat. If you want to send logs to multiple destinations (e.g., Elasticsearch and Kafka), you’ll need to use **Logstash** as a middle layer or run **multiple Filebeat instances**.


Absolutely! Here's a detailed explanation of the **Filebeat Modules** feature:

# Filebeat Modules 

## 📦 Filebeat Modules – Prebuilt Configs for Common Services

### ✅ What Are Filebeat Modules?

**Modules** in Filebeat are **preconfigured log collectors and parsers** for popular services such as:

- **Web servers**: Nginx, Apache
- **Databases**: MySQL, PostgreSQL
- **Operating system logs**: System, auditd, SSH
- **Security tools**: Suricata, Zeek
- **Cloud services**: AWS, GCP

These modules provide **ready-to-use configurations** that:
- Automatically define **input paths**
- Use **custom ingest pipelines** for parsing
- Apply **ECS (Elastic Common Schema)**-compliant field mapping
- Optionally include **Kibana dashboards**

---

### ⚙️ Example: Enabling the Nginx Module

```bash
sudo filebeat modules enable nginx
```

This will:
- Set up input paths for Nginx access and error logs
- Use built-in Elasticsearch ingest pipeline
- Parse logs into structured JSON fields like:
  - `nginx.access.remote_ip`
  - `nginx.access.response_code`
  - `nginx.error.message`
- Load a prebuilt Kibana dashboard (optional)

To disable it:
```bash
sudo filebeat modules disable nginx
```

---

### Filebeat Modules: Prebuilt Configurations for Common Services

Filebeat **Modules** are preconfigured sets of input, processor, and output configurations designed for **common log formats** and **services**. They help you quickly start collecting, parsing, and forwarding logs for services without needing to manually configure each part.

---

### 🧠 What Does a Module Contain?

A **Filebeat Module** typically includes:

1. **Input Configuration**:
   - Defines where Filebeat reads logs from.
   - Specifies file paths, types, and other related settings.

2. **Processors**:
   - Prepares and enriches logs.
   - Can include actions like parsing logs, extracting fields, and adding metadata.

3. **Output Configuration**:
   - Determines where the logs will be sent (Elasticsearch, Logstash, etc.).
   - Often comes with predefined templates and mappings.

4. **Kibana Dashboards**:
   - Modules often come with **prebuilt Kibana dashboards** for visualizing the logs.
   - These dashboards help you monitor services like Apache, Nginx, MySQL, and more.

---

### 🚀 Why Use Filebeat Modules?

1. **Quick Setup**: No need to create custom parsing rules or dashboards for popular services.
2. **Consistency**: Standardized configurations and visualizations that are widely used and trusted.
3. **Time-Saving**: Save time on parsing, field extractions, and visualizations for common services.

---

### 🛠️ How to Use a Filebeat Module

To enable and configure a module in Filebeat:

1. **List Available Modules**:
   ```bash
   filebeat modules list
   ```
   This command shows a list of available modules (e.g., nginx, apache2, mysql, etc.).

2. **Enable a Module**:
   For example, to enable the **Nginx module**, run:
   ```bash
   sudo filebeat modules enable nginx
   ```

3. **Configure the Module**:
   Each module has its own configuration file located in `/etc/filebeat/modules.d/`. You can configure log paths, processors, and other settings for each module:
   ```yaml
   filebeat.modules:
   - module: nginx
     access:
       enabled: true
       var.paths: ["/var/log/nginx/access.log"]
     error:
       enabled: true
       var.paths: ["/var/log/nginx/error.log"]
   ```

4. **Test Configuration**:
   Always test your Filebeat configuration before starting it to ensure everything is working properly:
   ```bash
   sudo filebeat test config
   ```

5. **Start Filebeat**:
   After configuring the module, you can start Filebeat:
   ```bash
   sudo systemctl start filebeat
   ```

6. **View the Logs in Kibana**:
   If you've configured the module correctly and are sending logs to Elasticsearch, you should be able to view them in Kibana with the prebuilt dashboards.

---

### 📊 Example: Nginx Module

The **Nginx module** is one of the most commonly used Filebeat modules. Here's what it does:

1. **Input**: Collects access and error logs from `/var/log/nginx/access.log` and `/var/log/nginx/error.log`.
2. **Processors**: 
   - Parses the Nginx log format.
   - Extracts common fields like the client IP, HTTP method, response code, etc.
3. **Output**: Sends the processed logs to Elasticsearch.
4. **Kibana Dashboards**: Provides prebuilt dashboards that help you visualize the Nginx logs, such as request statistics, error rates, and top URLs.

---

### 🧩 Structure of a Module

Each module typically includes:
- **Module config**: YAML file in `/etc/filebeat/modules.d/`
- **Ingest pipeline**: JSON processors for parsing
- **Dashboard files**: JSON visualizations for Kibana

---

### 💡 Benefits of Using Modules

- ✅ Faster setup for popular log sources
- ✅ ECS-compliant structure
- ✅ No need to manually write complex grok patterns
- ✅ Comes with dashboards to visualize data instantly

---


## 🧠 Filebeat Processors – Clean, Enrich & Customize Logs

***✅ What Are Processors?***

**Processors** in Filebeat are used to **modify, enrich, or filter log events** before they are sent to the output (like Elasticsearch or Logstash).

They run **after input and modules** have captured the logs, but **before the data is shipped**.

---

***🔧 Common Use Cases***

- Add fields like environment, region, hostname
- Remove sensitive or unnecessary fields
- Rename fields for consistency
- Drop events that match a condition
- Decode fields (e.g., base64, JSON)

---

***📘 Basic Processor Types***

| Processor           | Purpose                                  |
|---------------------|------------------------------------------|
| `add_fields`        | Add custom fields to events              |
| `drop_fields`       | Remove unwanted fields                   |
| `drop_event`        | Drop an entire event based on condition  |
| `rename`            | Rename fields                            |
| `include_fields`    | Only keep specific fields                |
| `decode_json_fields`| Parse embedded JSON in a field           |

---

***🛠️ How to Use Processors***

Processors go inside your `filebeat.yml` under the input or globally.

***🔹 Example 1: Add a field to all events***

```yaml
processors:
  - add_fields:
      target: ''
      fields:
        environment: production
        region: ap-south-1
```

***🔹 Example 2: Remove unwanted fields***

```yaml
processors:
  - drop_fields:
      fields: ["host", "agent", "input", "ecs"]
```

***🔹 Example 3: Drop events from localhost***

```yaml
processors:
  - drop_event:
      when:
        equals:
          source.ip: "127.0.0.1"
```

***🔹 Example 4: Decode embedded JSON***

```yaml
processors:
  - decode_json_fields:
      fields: ["message"]
      target: "json"
      overwrite_keys: true
```

---

## 🌐 Where to Place Processors?

- **Globally**: Apply to all inputs.
- **Under a specific input**: Only for that input block.
- **In modules**: Advanced customization (less common).

---

***✅ Best Practices***

- Keep processors minimal for performance.
- Use `drop_event` to reduce unnecessary indexing.
- Use `decode_json_fields` if your logs have nested JSON.
- Always test processor logic before production rollout.

Great question! Let’s break down what it means to use **processors under a specific input** in Filebeat:

---
# Under a Specific Input
## 🎯 What Does “Under a Specific Input” Mean?

In Filebeat, you can define **multiple inputs**, each watching different log files or directories.

Placing processors **under a specific input** means the processor will only apply to **logs collected by that input**, not globally to all logs.

---

***🔍 Why Use This?***

You might have:
- **Different logs** with different formats
- Logs that need **specific enrichment**
- A need to **drop or modify** certain fields only for one input

---

***🛠️ Example Configuration***

```yaml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /var/log/nginx/access.log
    processors:
      - add_fields:
          target: ''
          fields:
            service: nginx
            log_type: access

  - type: log
    enabled: true
    paths:
      - /var/log/mysql/mysql.log
    processors:
      - add_fields:
          target: ''
          fields:
            service: mysql
            log_type: database
```

***🔎 What This Does:***

- For **nginx logs**, Filebeat adds `service: nginx` and `log_type: access`
- For **MySQL logs**, Filebeat adds `service: mysql` and `log_type: database`

---

***✅ Benefits***

- Keeps processing logic **modular**
- Avoids affecting unrelated logs
- Makes your pipeline **cleaner and easier to debug**

---

You might have:
- **Different logs** with different formats
- Logs that need **specific enrichment**
- A need to **drop or modify** certain fields only for one input

---

***🛠️ Example Configuration***

```yaml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /var/log/nginx/access.log
    processors:
      - add_fields:
          target: ''
          fields:
            service: nginx
            log_type: access

  - type: log
    enabled: true
    paths:
      - /var/log/mysql/mysql.log
    processors:
      - add_fields:
          target: ''
          fields:
            service: mysql
            log_type: database
```

***🔎 What This Does:***

- For **nginx logs**, Filebeat adds `service: nginx` and `log_type: access`
- For **MySQL logs**, Filebeat adds `service: mysql` and `log_type: database`



***✅ Benefits***

- Keeps processing logic **modular**
- Avoids affecting unrelated logs
- Makes your pipeline **cleaner and easier to debug**

## Here's a **visual representation** of how **processors under specific inputs** work in Filebeat:

```
                                +-------------------------------+
                                |         filebeat.inputs       |
                                +-------------------------------+
                                         /             \
                                        /               \
                                       v                 v
                      +-----------------------+   +-------------------------+
                      |  Input: nginx logs    |   |  Input: MySQL logs      |
                      |  /var/log/nginx/...   |   |  /var/log/mysql/...     |
                      +----------+------------+   +------------+------------+
                                 |                             |
                                 v                             v
                   +---------------------------+   +---------------------------+
                   |  Processor (add_fields)   |   |  Processor (add_fields)   |
                   |  service: nginx           |   |  service: mysql           |
                   |  log_type: access         |   |  log_type: database       |
                   +-------------+-------------+   +-------------+-------------+
                                 |                             |
                                 v                             v
                          +--------------+             +---------------+
                          |   Output     |             |    Output     |
                          +--------------+             +---------------+
                                 |                             |
                                 v                             v
                         Elasticsearch / Logstash / Kafka / etc.
```

### 🧠 This diagram shows:
- Separate inputs for different logs
- Each input has its **own processors**
- Clean and modular routing of log data




