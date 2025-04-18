Got it! You want to set up the flow like this:

**Logstash ➝ Elasticsearch ➝ Kibana**

This means:
- Logstash collects and parses logs
- Sends them to Elasticsearch for indexing
- Kibana visualizes them

---

### ⚙️ Let's walk through the setup with this flow:

---

### ✅ 1. **Install Java (for Logstash)**

```bash
sudo apt update
sudo apt install -y openjdk-17-jdk
java -version
```

---

### ✅ 2. **Add Elastic GPG Key & Repository**

```bash
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg

echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt update
```

---

### ✅ 3. **Install Logstash**

```bash
sudo apt install logstash -y
```

We'll configure this in step 6.

---

### ✅ 4. **Install Elasticsearch**

```bash
sudo apt install elasticsearch -y
```

Config:

```bash
sudo nano /etc/elasticsearch/elasticsearch.yml
```

Set:
```yaml
network.host: localhost
```

Start and enable:

```bash
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch
```

---

### ✅ 5. **Install Kibana**

```bash
sudo apt install kibana -y
```

Config:

```bash
sudo nano /etc/kibana/kibana.yml
```

Set:
```yaml
server.host: "localhost"
elasticsearch.hosts: ["http://localhost:9200"]
```

Start and enable:

```bash
sudo systemctl enable kibana
sudo systemctl start kibana
```

Kibana will be available at:  
**http://localhost:5601**

---

### ✅ 6. **Logstash ➝ Elasticsearch Config**

Create a Logstash config file:

```bash
sudo nano /etc/logstash/conf.d/example.conf
```

Example config:
```conf
input {
  file {
    path => "/var/log/syslog"
    start_position => "beginning"
  }
}

filter {
  grok {
    match => { "message" => "%{SYSLOGTIMESTAMP:timestamp} %{SYSLOGHOST:host} %{DATA:program}(?:\[%{POSINT:pid}\])?: %{GREEDYDATA:msg}" }
  }
}

output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "syslog-%{+YYYY.MM.dd}"
  }
}
```

---

### ✅ 7. **Start Logstash**

```bash
sudo systemctl enable logstash
sudo systemctl start logstash
```

---

### ✅ 8. **View Logs in Kibana**

1. Open Kibana: `http://localhost:5601`
2. Go to **“Discover”**
3. Create an index pattern: `syslog-*`
4. Set time field to `timestamp`

---

Let me know if:
- You want to forward from remote servers
- You want to parse specific logs (HAProxy, nginx, etc.)
- Or set up Filebeat for lightweight log shipping

Ready for next steps?
