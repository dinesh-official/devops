# Elastic Stack (ELK Stack) Installation Guide — Elasticsearch 7.7.1

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
> This guide uses **version 7.7.1** of Elasticsearch, Kibana, and Filebeat.

## 𝔸 Architecture

```
+-----------------+     +-------------------+     +-------------------+
| Filebeat        | --> | Elasticsearch     | --> | Kibana            |
| (Collects Logs) |     | (Stores Logs)     |     | (Visualizes Data) |
+-----------------+     +-------------------+     +-------------------+
        |                     |                        |
        v                     v                        v
   Logs (e.g.,            Data Indexed in           Dashboards,
   system logs)          Elasticsearch             Visualizations
                         (e.g., filebeat-* index)    in Kibana
```

---

## 🏆 Step 1 — Installing and Configuring Elasticsearch

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

```bash
sudo nano /etc/elasticsearch/elasticsearch.yml
```

Add this:
```yml
network.host: localhost
discovery.type: single-node
```

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

## 🚀 Step 2 — Installing and Configuring the Kibana Dashboard

```bash
sudo apt install kibana
sudo systemctl enable kibana
sudo systemctl start kibana
sudo apt install nginx -y
```

Create basic auth for Nginx:
```bash
echo "kibanaadmin:$(openssl passwd -apr1)" | sudo tee -a /etc/nginx/htpasswd.users
```

Configure Nginx reverse proxy:
```bash
sudo nano /etc/nginx/sites-available/your_domain
```

Example config:
```nginx
server {
    listen 80;
    server_name your_domain_or_server_ip;

    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/htpasswd.users;

    location / {
        proxy_pass http://localhost:5601;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

To automate the above:
```bash
echo -e "server {\n    listen 80;\n    server_name your_domain_or_server_ip;\n\n    auth_basic \"Restricted Access\";\n    auth_basic_user_file /etc/nginx/htpasswd.users;\n\n    location / {\n        proxy_pass http://localhost:5601;\n        proxy_http_version 1.1;\n        proxy_set_header Upgrade \$http_upgrade;\n        proxy_set_header Connection 'upgrade';\n        proxy_set_header Host \$host;\n        proxy_cache_bypass \$http_upgrade;\n    }\n}" | sudo tee /etc/nginx/sites-available/your_domain_or_server_ip
```

Allow Kibana to listen on all interfaces:
```bash
sudo sed -i 's|#\?server.host:.*|server.host: "0.0.0.0"|' /etc/kibana/kibana.yml
sudo systemctl restart kibana
sudo ufw allow 5601/tcp && sudo ufw reload
sudo systemctl enable kibana
sudo nginx -t && sudo systemctl restart nginx
```

Visit: `http://your_domain/status`

---

## 📁 Step 3 — Installing and Configuring Filebeat

```bash
sudo apt install filebeat
sudo nano /etc/filebeat/filebeat.yml
```

Modify Filebeat output:
```yml
output.elasticsearch:
  hosts: ["localhost:9200"]

# Comment out Logstash output
#output.logstash:
#  hosts: ["localhost:5044"]
```

Enable system module:
```bash
sudo filebeat modules enable system
```

Set up pipelines:
```bash
sudo filebeat setup --pipelines --modules system
```

Load index template:
```bash
sudo filebeat setup --index-management -E output.elasticsearch.enabled=true -E 'output.elasticsearch.hosts=["localhost:9200"]'
```

Load Kibana dashboards:
```bash
sudo filebeat setup -E output.elasticsearch.enabled=true -E 'output.elasticsearch.hosts=["localhost:9200"]' -E setup.kibana.host=localhost:5601
```

Start and enable Filebeat:
```bash
sudo systemctl start filebeat
sudo systemctl enable filebeat
```

---

✅ **Elastic Stack setup complete!**

You should now be able to see logs flowing into Kibana from Filebeat.

### know more
***Filebeat***
If you want to know more about Filebeat, explore the detailed setup and configurations in my GitHub [Filebeat Guide](https://github.com/dinesh-official/devops/blob/main/filebeat.md).



