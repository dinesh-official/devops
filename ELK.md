Perfect, Hasan! Here's a **complete, production-ready ELK stack setup guide on Ubuntu 22.04**, with all necessary configurations and best practices.

---

## 🔧 **Phase 1: System Preparation (Before Installing ELK)**

### ✅ 1. Update & Upgrade Your System
```bash
sudo apt update && sudo apt upgrade -y
```

### ✅ 2. Set the Hostname (Optional but clean)
```bash
sudo hostnamectl set-hostname elk-node
```

### ✅ 3. Add Elastic GPG Key and Repository
```bash
sudo apt install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
```

---

## 🔁 **Phase 2: Install & Configure Elasticsearch**

### ✅ 1. Install Elasticsearch
```bash
sudo apt update
sudo apt install -y elasticsearch
```

### ✅ 2. Disable SSL and Security for Simplicity (Dev Mode)
Edit the config:
```bash
sudo nano /etc/elasticsearch/elasticsearch.yml
```

Add/Uncomment:
```yaml
network.host: 0.0.0.0
http.port: 9200
discovery.type: single-node

xpack.security.enabled: false
xpack.security.http.ssl.enabled: false
```

### ✅ 3. Start and Enable Elasticsearch
```bash
sudo systemctl daemon-reexec
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch
```

### ✅ 4. Test Elasticsearch
```bash
curl http://localhost:9200
```

---

## 📦 **Phase 3: Install & Configure Kibana**

### ✅ 1. Install Kibana
```bash
sudo apt install -y kibana
```

### ✅ 2. Configure Kibana
Edit:
```bash
sudo nano /etc/kibana/kibana.yml
```

Set:
```yaml
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://localhost:9200"]
xpack.security.enabled: false
```

### ✅ 3. Start & Enable Kibana
```bash
sudo systemctl enable kibana
sudo systemctl start kibana
```

### ✅ 4. Access Kibana
Open your browser:
```
http://<your-server-ip>:5601
```

---

## 📊 **Phase 4: Install & Configure Logstash**

### ✅ 1. Install Logstash
```bash
sudo apt install -y logstash
```

### ✅ 2. Create Test Pipeline
```bash
sudo nano /etc/logstash/conf.d/syslog.conf
```

Add:
```conf
input {
  file {
    path => "/var/log/syslog"
    start_position => "beginning"
  }
}

filter {
  grok {
    match => { "message" => "%{SYSLOGTIMESTAMP:timestamp} %{SYSLOGHOST:hostname} %{DATA:program}(?:\[%{POSINT:pid}\])?: %{GREEDYDATA:msg}" }
  }
  date {
    match => [ "timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
  }
}

output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "syslog-%{+YYYY.MM.dd}"
  }
  stdout { codec => rubydebug }
}
```

### ✅ 3. Test Config
```bash
sudo /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/syslog.conf --config.test_and_exit
```

### ✅ 4. Start & Enable Logstash
```bash
sudo systemctl enable logstash
sudo systemctl start logstash
```

---

## ✅ **Phase 5: Final Touch – Kibana Index Pattern**

1. Go to Kibana → **Management** → **Stack Management** → **Index Patterns**
2. Create index pattern: `syslog-*`
3. Set `@timestamp` as the time field.

---

## 🛡️ Production-Ready Enhancements (Optional but Recommended)

| Feature | Description |
|--------|-------------|
| **Nginx reverse proxy** | Add HTTPS, Basic Auth |
| **UFW Firewall** | Allow only ports 22, 9200, 5601 |
| **Filebeat** | Forward logs from other servers |
| **SSL and Authentication** | Use built-in X-Pack in Elastic 8.x |
| **Monitoring** | Enable monitoring in Kibana |
| **Backups** | Use snapshot repositories |

---

## ✅ Useful Commands

| Task | Command |
|------|---------|
| Restart ELK services | `sudo systemctl restart elasticsearch logstash kibana` |
| View logs | `journalctl -u elasticsearch` (same for kibana/logstash) |
| Test config | `logstash --config.test_and_exit -f /etc/logstash/conf.d/` |

---

Let me know once you finish any phase, and I’ll guide you through the next steps or help troubleshoot anything. Want to start with Elasticsearch now?
