**Title: Elasticsearch 3-Node Master-Slave (Highly Available) Cluster Setup Guide**

---

### 📄 Overview

This guide explains how to set up a **3-node Elasticsearch cluster** where:

* One node acts as the **master**.
* The other two act as **data/slave** nodes.
* If the master goes down, one of the remaining nodes automatically takes over as the new master (high availability).

---

### 🎨 Architecture Diagram

```
+------------------+       +------------------+       +------------------+
|   Node 1         |       |   Node 2         |       |   Node 3         |
|  (Master-eligible)| <--->| (Master-eligible) | <--->| (Master-eligible) |
|   IP: 10.0.0.1   |       |   IP: 10.0.0.2   |       |   IP: 10.0.0.3   |
|   Roles: master, |       |   Roles: master, |       |   Roles: master, |
|          data    |       |          data    |       |          data    |
+------------------+       +------------------+       +------------------+

         ↑                    ↑                    ↑
         ┃                    ┃                    ┃
         └-- All nodes talk to each other for cluster discovery --┘
```

---

### ⚙️ Steps to Configure Each Node

Assuming you're using Elasticsearch 7.x or 8.x on **Linux** (Rocky, Ubuntu, etc.)

#### 1. **Install Elasticsearch on All Nodes**

Follow the standard RPM/DEB Elasticsearch installation guide for each server.

#### 2. **Configure elasticsearch.yml**

On each node, edit `/etc/elasticsearch/elasticsearch.yml`:

Example for **Node 1** (IP: `10.0.0.1`):

```yaml
cluster.name: my-ha-cluster
node.name: node-1
node.roles: [master, data]
network.host: 10.0.0.1
http.port: 9200

# Cluster discovery settings
discovery.seed_hosts: ["10.0.0.1", "10.0.0.2", "10.0.0.3"]
cluster.initial_master_nodes: ["node-1", "node-2", "node-3"]
```

Repeat this for **Node 2** and **Node 3**, just changing `node.name` and `network.host` accordingly.

#### 3. **Open Firewall Ports**

Ensure the following ports are open between nodes:

* **9200** (HTTP)
* **9300** (Transport communication between nodes)

#### 4. **Start and Enable Elasticsearch**

```bash
sudo systemctl daemon-reexec
sudo systemctl enable --now elasticsearch
```

Check logs:

```bash
journalctl -u elasticsearch -f
```

#### 5. **Verify the Cluster**

From any node:

```bash
curl -X GET http://10.0.0.1:9200/_cluster/health?pretty
curl -X GET http://10.0.0.1:9200/_cat/nodes?v
```

Look for `status: green` and all 3 nodes listed.

---

### ❓ How Master Election Works

* Elasticsearch automatically elects a **master node** from nodes with `master` role.
* If the current master fails, a new master is elected from the remaining eligible nodes.
* To ensure high availability, always have **at least 3 master-eligible nodes**.

---

### 🔒 Security (Optional but Recommended)

Enable TLS and authentication with X-Pack:

```yaml
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true
```

Run setup passwords:

```bash
/usr/share/elasticsearch/bin/elasticsearch-setup-passwords interactive
```

---

Here’s how to **create a new index** (e.g., `my-index`) in your Elasticsearch cluster using `curl`, customized for your setup:

---

### ✅ **Command to Create Index `my-index`** with 3 shards and 1 replica:

```bash
curl -X PUT "http://10.20.44.16:9200/my-index" -H 'Content-Type: application/json' -d '
{
  "settings": {
    "number_of_shards": 3,
    "number_of_replicas": 1
  }
}'
```

---

### 🔍 Explanation:

| Setting              | Value | Meaning                                             |
| -------------------- | ----- | --------------------------------------------------- |
| `number_of_shards`   | 3     | Splits index into 3 primary shards (1 per node)     |
| `number_of_replicas` | 1     | Each primary shard has 1 backup (high availability) |

---

### ✅ Verify the index:

```bash
curl -X GET "http://10.20.44.16:9200/_cat/indices?v"
```

It should now show `my-index` in the list.

Let me know if you want to define **mappings** (like data types) or set **custom index patterns** next.

