ElastAlert File Structure: Required Files
```
elastalert/
├── config.yaml                 <-- 🔧 Main ElastAlert configuration
├── rules/                     <-- 📂 Folder containing alert rule files
│   └── <your_rule>.yaml       <-- 📜 Custom rule for alerting
├── elastalert.log             <-- 📄 Optional log file if logging is enabled
├── smtp_auth.yaml             <-- 🔐 Optional, for SMTP credentials (if separate)
├── elastalert_status (index)  <-- 🛢️ ES index used internally by ElastAlert
└── requirements.txt           <-- 📦 Python dependencies (if needed)
```
How They Work Together

```
[Filebeat] → [Elasticsearch] ← [ElastAlert] → [Rules] → [SMTP / Slack / Webhook]
                                     ↑
                            uses config.yaml

```
