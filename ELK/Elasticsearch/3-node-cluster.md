# 🛡️ Elasticsearch High Availability Cluster (3-Node Setup)

---

## ✅ Single Node - (Optional for Testing Only)

Use this config for a simple, non-secure, single-node Elasticsearch test setup:

```yaml
cluster.name: elk-cluster
node.name: elk-node

path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch

network.host: 0.0.0.0
http.port: 9200

discovery.type: single-node

xpack.security.enabled: false
xpack.security.http.ssl.enabled: false
```

> Save to: `/etc/elasticsearch/elasticsearch.yml`

```bash
sudo systemctl restart elasticsearch
curl http://localhost:9200
```

---

## 🔧 Multi-Node Cluster Setup (High Availability)

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

### 🧠 Cluster Role Design:

All 3 nodes will act as:

* Master-eligible
* Data nodes
* Ingest nodes

> ⚠️ Quorum needs **at least 2 active master-eligible nodes**.

| Node Name | IP Address | Roles        |
| --------- | ---------- | ------------ |
| es-node-1 | 10.0.0.1   | master, data |
| es-node-2 | 10.0.0.2   | master, data |
| es-node-3 | 10.0.0.3   | master, data |

---

### 🔹 Node 1 Config (`es-node-1`)

```yaml
cluster.name: elk-cluster
node.name: es-node-1

path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch

network.host: 10.0.0.1
http.port: 9200

discovery.seed_hosts: ["10.0.0.2", "10.0.0.3"]
cluster.initial_master_nodes: ["es-node-1", "es-node-2", "es-node-3"]

xpack.security.enabled: false
xpack.security.http.ssl.enabled: false
```

### 🔹 Node 2 Config (`es-node-2`)

```yaml
cluster.name: elk-cluster
node.name: es-node-2

path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch

network.host: 10.0.0.2
http.port: 9200

discovery.seed_hosts: ["10.0.0.1", "10.0.0.3"]
cluster.initial_master_nodes: ["es-node-1", "es-node-2", "es-node-3"]

xpack.security.enabled: false
xpack.security.http.ssl.enabled: false
```

### 🔹 Node 3 Config (`es-node-3`)

```yaml
cluster.name: elk-cluster
node.name: es-node-3

path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch

network.host: 10.0.0.3
http.port: 9200

discovery.seed_hosts: ["10.0.0.1", "10.0.0.2"]
cluster.initial_master_nodes: ["es-node-1", "es-node-2", "es-node-3"]

xpack.security.enabled: false
xpack.security.http.ssl.enabled: false
```

---

### 🚀 Deployment Steps for All 3 Nodes:

1. Save config to `/etc/elasticsearch/elasticsearch.yml`
2. Start or restart the service:

```bash
sudo systemctl restart elasticsearch
```

3. Check status:

```bash
curl -X GET http://localhost:9200/_cluster/health?pretty
curl -X GET http://localhost:9200/_cat/nodes?v
```

> All 3 nodes should appear in the cluster.

### Example output

```
curl -X GET http://10.20.44.16:9200/_cluster/health?pretty
curl -X GET http://10.20.44.16:9200/_cat/nodes?v
{
  "cluster_name" : "my-ha-cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 3,
  "number_of_data_nodes" : 3,
  "active_primary_shards" : 3,
  "active_shards" : 6,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
ip          heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
10.20.44.19           11          80  24    0.76    0.25     0.08 dm        -      node-2
10.20.44.16            7          74   0    0.07    0.08     0.03 dm        -      node-1
10.20.44.18           17          81  25    0.78    0.34     0.12 dm        *      node-2

```

---
