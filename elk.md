# 🚀 Elastic Stack (ELK Stack) Installation Guide — Elasticsearch 7.7.1

The **Elastic Stack** — formerly known as the **ELK Stack** — is a collection of open-source software produced by Elastic. It enables you to search, analyze, and visualize logs from any source and in any format — a practice known as centralized logging.

Centralized logging is helpful for:
- Identifying problems with your servers or applications
- Searching logs from a single place
- Correlating events across multiple servers by time

## 🔧 Components

```
Filebeat → Elasticsearch → Kibana
```

> ⚠️ **Note:** When installing the Elastic Stack, all components must use the **same version**.  
> This guide uses **version 7.7.1** of Elasticsearch, Kibana, Logstash, and Filebeat.

---

## 🥇 Step 1 — Installing and Configuring Elasticsearch

### 1. Add GPG Key

```bash
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
```

### 2. Add APT Repository

```bash
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
```

### 3. Update Package Index

```bash
sudo apt update
```

### 4. Install Elasticsearch

```bash
sudo apt install elasticsearch
```

### 5. Configure Elasticsearch to Listen on All Interfaces

```bash
echo -e "network.host: 0.0.0.0\ndiscovery.type: single-node" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
```

> Optional: To edit manually instead  
> ```bash
> sudo nano /etc/elasticsearch/elasticsearch.yml
> ```
> Add this 
> ```bash
> ...
># ---------------------------------- Network -----------------------------------
>#
># Set the bind address to a specific IP (IPv4 or IPv6):
>#
>network.host: localhost
>discovery.type: single-node
>...
> ```

### 6. Start and Enable Elasticsearch

```bash
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
```

### 7. Verify Installation

```bash
curl -X GET "localhost:9200"
```

#### ✅ Expected Output:

```json
{
  "name" : "Elasticsearch",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "n8Qu5CjWSmyIXBzRXK-j4A",
  "version" : {
    "number" : "7.17.2",
    "build_flavor" : "default",
    "build_type" : "deb",
    "build_hash" : "de7261de50d90919ae53b0eff9413fd7e5307301",
    "build_date" : "2022-03-28T15:12:21.446567561Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

---

✅ **Elasticsearch is now installed and running!**  
➡️ Continue with Kibana, Filebeat, and optionally Logstash in the next steps.
