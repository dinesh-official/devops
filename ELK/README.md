# ELK stack (Elasticsearch,Logstash,Kibana) with Filebeat on Ubuntu 22.04  
**send logs from Filebeat to Logstash and then to Elasticsearch for visualization in Kibana, follow the detailed guide below:**

---

### **1. Install Elasticsearch on Ubuntu 22.04**

#### Step 1: Install the public signing key and repository

Run the following commands to install Elasticsearch:

```bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-archive-keyring.gpg
```

Add the repository:

```bash
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-archive-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
```

#### Step 2: Update the repository and install Elasticsearch

```bash
sudo apt-get update
sudo apt-get install elasticsearch
```

#### Step 3: Start and enable Elasticsearch

Start and enable Elasticsearch to automatically start on boot:

```bash
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
```

#### Step 4: Verify Elasticsearch is running

Check the status of Elasticsearch:

```bash
curl -X GET "localhost:9200/"
```

You should receive a JSON response with details about the Elasticsearch node.

---

### **2. Install Logstash on Ubuntu 22.04**

#### Step 1: Install Logstash

Install Logstash using the APT repository:

```bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/logstash-archive-keyring.gpg
```

Add the Logstash repository:

```bash
echo "deb [signed-by=/usr/share/keyrings/logstash-archive-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
```

Update the repository and install Logstash:

```bash
sudo apt-get update
sudo apt-get install logstash
```

#### Step 2: Start and enable Logstash

Start Logstash and enable it to start on boot:

```bash
sudo systemctl start logstash
sudo systemctl enable logstash
```

---

### **3. Install Kibana on Ubuntu 22.04**

#### Step 1: Install Kibana

Install Kibana from the Elastic repository:

```bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/kibana-archive-keyring.gpg
```

Add the Kibana repository:

```bash
echo "deb [signed-by=/usr/share/keyrings/kibana-archive-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
```

Update the repository and install Kibana:

```bash
sudo apt-get update
sudo apt-get install kibana
```

#### Step 2: Start and enable Kibana

Start Kibana and enable it to start on boot:

```bash
sudo systemctl start kibana
sudo systemctl enable kibana
```

#### Step 3: Verify Kibana is running

Access Kibana by opening a browser and navigating to:

```
http://localhost:5601
```

You should see the Kibana dashboard.

---

### **4. Install Filebeat on Ubuntu 22.04**

#### Step 1: Install Filebeat

Install Filebeat from the Elastic repository:

```bash
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/filebeat-archive-keyring.gpg
```

Add the Filebeat repository:

```bash
echo "deb [signed-by=/usr/share/keyrings/filebeat-archive-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
```

Update the repository and install Filebeat:

```bash
sudo apt-get update
sudo apt-get install filebeat
```

#### Step 2: Configure Filebeat

Edit the Filebeat configuration to send logs to Logstash:

```bash
sudo nano /etc/filebeat/filebeat.yml
```

Find the `output.logstash` section and configure it to point to your Logstash server:

```yaml
output.logstash:
  hosts: ["localhost:5044"]
```

If you have a remote Logstash server, replace `localhost` with the remote server's IP.

#### Step 3: Enable and start Filebeat

Start Filebeat and enable it to start on boot:

```bash
sudo systemctl start filebeat
sudo systemctl enable filebeat
```

#### Step 4: Test Filebeat

You can check if Filebeat is sending logs by running:

```bash
sudo filebeat test output
```

---

### **5. Configure Logstash to Receive Logs from Filebeat**

#### Step 1: Create a Logstash pipeline configuration

Create a new pipeline configuration for Logstash:

```bash
sudo nano /etc/logstash/conf.d/filebeat.conf
```

Add the following configuration to parse logs from Filebeat and send them to Elasticsearch:

```plaintext
input {
  beats {
    port => 5044
  }
}

filter {
  # Add any filtering rules here (e.g., parsing, grok)
}

output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "filebeat-%{+YYYY.MM.dd}"
  }
}
```

#### Step 2: Start Logstash with the new configuration

Start Logstash:

```bash
sudo systemctl restart logstash
```

---

### **6. Verify the ELK Stack is Working**

#### Step 1: Verify Filebeat data in Elasticsearch

Check that data from Filebeat is being sent to Elasticsearch:

```bash
curl -X GET "localhost:9200/filebeat-*/_search?pretty"
```

You should see log data in the output.

#### Step 2: Visualize data in Kibana

1. Open Kibana in your browser:

   ```
   http://localhost:5601
   ```

2. Go to **Management > Kibana Index Patterns**.

3. Create a new index pattern for `filebeat-*`.

4. Select `@timestamp` as the time field and click **Create index pattern**.

5. Now you can go to **Discover** and view the logs being indexed by Elasticsearch.

---

### **7. Optional: Configure Kibana Dashboards**

You can import predefined Kibana dashboards for Filebeat:

1. Import the default Filebeat dashboards:

   ```bash
   sudo filebeat setup --dashboards
   ```

2. After the import, go to **Kibana > Dashboards** to view the pre-configured Filebeat dashboards.

---

### **Conclusion**

You now have the complete ELK stack with Filebeat sending logs to Logstash and Elasticsearch. Kibana is set up for visualization, and you can use it to analyze the logs in real-time.

