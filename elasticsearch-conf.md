Here's your **modified `elasticsearch.yml`** file, based on a **single-node, non-secured setup**, with everything necessary to get it running:

---

### ✅ **Production-Ready Single Node (No Security) Config:**

```yaml
# ======================== Elasticsearch Configuration =========================

# ---------------------------------- Cluster -----------------------------------
cluster.name: elk-cluster

# ------------------------------------ Node ------------------------------------
node.name: elk-node

# ----------------------------------- Paths ------------------------------------
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch

# ----------------------------------- Network -----------------------------------
network.host: 0.0.0.0
http.port: 9200

# --------------------------------- Discovery -----------------------------------
discovery.type: single-node
#cluster.initial_master_nodes: ["elk-node"]

# ---------------------------- X-Pack (Security) -------------------------------
xpack.security.enabled: false
xpack.security.http.ssl.enabled: false
```

---

### ✅ Now do the following:

1. **Save this configuration** to your `/etc/elasticsearch/elasticsearch.yml` file.
   ```bash
   sudo nano /etc/elasticsearch/elasticsearch.yml
   ```
   Paste the config above and save (`Ctrl + O`, `Enter`, `Ctrl + X`).

2. **Restart Elasticsearch:**
   ```bash
   sudo systemctl restart elasticsearch
   ```

3. **Check status:**
   ```bash
   sudo systemctl status elasticsearch
   ```

4. **Test connection:**
   ```bash
   curl http://localhost:9200
   ```

Let me know if you want to enable security later or integrate it with Kibana 👍
