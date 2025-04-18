

## 💡 Why Do We Need a Pipeline in Logstash?

A **pipeline** in Logstash is **the brain that handles your logs** — from how they come in, how they’re processed, and where they go.

---

## 📦 Think of a Pipeline Like This:

> "Raw logs come in → Logstash cleans and structures them → Sends them to Elasticsearch"

Without a pipeline, Logstash wouldn’t know:
- **Where to receive the logs**
- **How to parse or filter the logs**
- **Where to send the logs**

---

## 🧱 Pipeline = 3 Building Blocks

```
┌────────┐     ┌─────────┐     ┌─────────────┐
│ INPUT  │ ==> │ FILTER  │ ==> │  OUTPUT     │
└────────┘     └─────────┘     └─────────────┘
```

Let’s break down each:

| Part    | What it Does                            | Example                        |
|---------|------------------------------------------|--------------------------------|
| `input` | Where the logs are coming from           | Filebeat, syslog, Kafka        |
| `filter`| How logs are parsed and enriched         | grok, date, geoip, mutate      |
| `output`| Where to send the logs                   | Elasticsearch, file, stdout    |

---

## ✅ What Pipelines Let You Do:

- 🔍 **Parse raw logs** (turn plain text into structured data)
- 📅 **Fix timestamps**
- 🔐 **Anonymize or enrich data** (e.g., add geo-location from IP)
- 📤 **Send to multiple places** (e.g., Elasticsearch + backup file)

---

## 📈 Without Pipelines?

If you didn’t have a pipeline:
- Logstash wouldn't accept any logs
- Nothing would get parsed or structured
- You wouldn’t see anything in Kibana

---

## 🔁 Real-Life Example (Simple Flow)

```
[ Filebeat ]  =>  [ Logstash Pipeline ]
                      ├─ input (beats)
                      ├─ filter (grok, date, mutate)
                      └─ output (Elasticsearch)
                                ↓
                          [ Kibana Dashboard ]
```

> 🔹 Getting logs from Filebeat  
> 🔹 Sending them to Logstash  
> 🔹 Parsing them in Logstash  
> 🔹 Then storing them in Elasticsearch  
> 🔹 Finally, visualizing them in Kibana

---

## 📄 Text Architecture: ELK Pipeline Flow

```
┌────────────┐          ┌────────────┐          ┌───────────────┐         ┌──────────────┐
│  Filebeat  │ ───────▶ │  Logstash  │ ───────▶ │ Elasticsearch │ ─────▶  │   Kibana     │
└────────────┘          └────┬───────┘          └───────────────┘         └──────────────┘
                             │
         ┌───────────────────┴─────────────────────┐
         │       Logstash Pipeline Structure       │
         └─────────────────────────────────────────┘
                      │
       ┌──────────────┼──────────────┐
       │              │              │
  ┌─────────┐    ┌───────────┐   ┌──────────────┐
  │  input  │ => │  filter   │ =>│   output     │
  └─────────┘    └───────────┘   └──────────────┘
       │              │              │
       ▼              ▼              ▼
  beats plugin     grok, date,     elasticsearch
                   mutate, etc.    output plugin
```

---

## ✅ Step-by-Step Example

### 🎯 1. Filebeat (Log Forwarder)
- Installed on the client/server sending logs
- Sends logs to Logstash on port `5044`

**Filebeat config:**
```yaml
output.logstash:
  hosts: ["logstash-server-ip:5044"]
```

---

### 🎯 2. Logstash Pipeline Configuration (`/etc/logstash/conf.d/app-logs.conf`)

```ruby
input {
  beats {
    port => 5044
  }
}

filter {
  grok {
    match => { "message" => "%{COMBINEDAPACHELOG}" }
  }
  date {
    match => ["timestamp", "dd/MMM/yyyy:HH:mm:ss Z"]
    target => "@timestamp"
  }
}

output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "app-logs-%{+YYYY.MM.dd}"
  }
}
```

---

## 🔍 How the Pipeline Works

| Component       | What It Does                                                                 |
|-----------------|------------------------------------------------------------------------------|
| **input**       | Accepts logs from Filebeat (via Beats input plugin)                          |
| **filter**      | Parses logs using `grok`, sets proper timestamp using `date` plugin          |
| **output**      | Sends structured logs to Elasticsearch using the `elasticsearch` plugin      |

---

## 📂 Pipeline File Location

Put the config file in:
```
/etc/logstash/conf.d/app-logs.conf
```

Then restart Logstash:
```bash
sudo systemctl restart logstash
```

