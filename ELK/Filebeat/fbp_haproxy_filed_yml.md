```  GNU nano 6.2                                                                                               /etc/filebeat/filebeat.yml                                                                                                        
filebeat.inputs:
  - type: log
    paths:
      - /var/log/remote_logs/myaccount-apilb-new/haproxy.log
    fields_under_root: true
    processors:
      - dissect:
          tokenizer: "%{syslog.timestamp} %{host.name} %{process.name}[%{process.pid}]: %{source_ip}:%{source_port} [%{haproxy.accept_date}] %{haproxy.frontend} %{haproxy.backend}/%{haproxy.server} %{haproxy.Tq}/%{haproxy.Tw}/%{haproxy.Tc>
          field: "message"
          target_prefix: "parsed"

# Output configuration
output.elasticsearch:
  hosts: ["http://localhost:9200"]
  index: "haproxy-%{+yyyy.MM.dd}"  # Custom index name with date pattern

# Setup template settings
setup.template.name: "haproxy"
setup.template.pattern: "haproxy-*"

# Optional: Setup Kibana
setup.kibana:
  host: "http://localhost:5601"

# Logging settings
logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat.log
  keepfiles: 7
  permissions: 0644

```
