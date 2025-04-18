Got it, Hasan. Let’s go for the most **stable and production-ready version** of ELK stack — compatible, clean, and less error-prone.

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

## 🎯 Final Step: Create Kibana Index Pattern

1. Visit Kibana at `http://<IP>:5601`
2. Go to **Stack Management → Index Patterns**
3. Add: `logstash-*` or `syslog-*` as index pattern
4. Choose `@timestamp` as time field

---

✅ **Stable ELK 7.17.16 should now work flawlessly without SSL or auth headaches.**

Let me know if you want me to script the whole install or troubleshoot an error you're seeing.
