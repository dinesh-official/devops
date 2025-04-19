
### ✅ How to Create an Index in Elasticsearch via CLI

#### 🔧 Basic Command (Assuming Elasticsearch is running on `localhost:9200`)

```bash
curl -X PUT "http://localhost:9200/your-index-name" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 1
  }
}
'
```

> 🔁 Replace `your-index-name` with your actual index name, like `filebeat-custom`.

---

### 🧪 Example: Create an index called `filebeat-custom`

```bash
curl -X PUT "http://localhost:9200/filebeat-custom" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 1
  }
}
'
```

---

### 🔐 If You Use Security (Elasticsearch 7+ with basic auth):

```bash
curl -u elastic:your-password -X PUT "http://localhost:9200/filebeat-custom" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 1
  }
}
'
```

---

### 🔍 Verify Index Exists

```bash
curl -X GET "http://localhost:9200/_cat/indices?v"
```

---

### 📦 Bonus: Create Index with Mappings (if needed)

```bash
curl -X PUT "http://localhost:9200/my-index-with-mapping" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1
  },
  "mappings": {
    "properties": {
      "@timestamp": { "type": "date" },
      "message":     { "type": "text" },
      "host": {
        "properties": {
          "name": { "type": "keyword" }
        }
      }
    }
  }
}
'
```
