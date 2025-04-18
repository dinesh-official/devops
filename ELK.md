Perfect! Let’s get **ELK Stack** (Elasticsearch, Logstash, Kibana) installed and fully set up on your **Ubuntu 22.04** node — from scratch.

---

### 🧱 Stack Overview:
- **Elasticsearch**: stores and indexes logs.
- **Logstash**: ingests and parses logs.
- **Kibana**: visualizes logs.

---

### 🧰 Step 1: Install Java (Required for Logstash)

```bash
sudo apt update
sudo apt install -y openjdk-17-jdk
java -version
```

---

### 📦 Step 2: Add Elastic GPG Key and Repository

```bash
curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg

echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt update
```

---

### 🔍 Step 3: Install Elasticsearch

```bash
sudo apt install elasticsearch -y
```

Edit the config:

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

### 🔐 Step 4: Set Up Elasticsearch Security

Run setup:
```bash
sudo /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic
```

Save the password shown — you'll use this for Kibana and Logstash.

---

### 📊 Step 5: Install Kibana

```bash
sudo apt install kibana -y
```

Edit config:

```bash
sudo nano /etc/kibana/kibana.yml
```

Set:
```yaml
server.host: "localhost"
elasticsearch.hosts: ["http://localhost:9200"]
elasticsearch.username: "elastic"
elasticsearch.password: "<your_elastic_password>"
```

Start and enable:

```bash
sudo systemctl enable kibana
sudo systemctl start kibana
```

Check: [http://localhost:5601](http://localhost:5601)

---

### 🔁 Step 6: Install Logstash

```bash
sudo apt install logstash -y
```

You can now create a config file for ingesting logs.

Example config:  
Create a file:
```bash
sudo nano /etc/logstash/conf.d/syslog.conf
```

Paste:

```conf
input {
  file {
    path => "/var/log/syslog"
    start_position => "beginning"
  }
}

filter {
  grok {
    match => { "message" => "%{SYSLOGTIMESTAMP:timestamp} %{SYSLOGHOST:host} %{DATA:program}(?:\[%{POSINT:pid}\])?: %{GREEDYDATA:log_message}" }
  }
}

output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    user => "elastic"
    password => "<your_elastic_password>"
    index => "syslog-%{+YYYY.MM.dd}"
  }
}
```

---

### ▶️ Step 7: Test and Start Logstash

Test:
```bash
sudo /usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/syslog.conf --config.test_and_exit
```

If all good:

```bash
sudo systemctl enable logstash
sudo systemctl start logstash
```

---

### 📈 Step 8: Visualize in Kibana

1. Open `http://localhost:5601`
2. Go to **"Discover"**
3. Create index pattern: `syslog-*`
4. Select time field: `timestamp`

---

### ✅ Done!

Would you also like:
- To forward HAProxy or Nginx logs?
- To install Filebeat?
- To secure the stack with HTTPS or a reverse proxy?

Let me know what you need next!
