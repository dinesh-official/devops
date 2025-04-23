 ``` GNU nano 6.2                                                                                               /etc/filebeat/filebeat.yml                                                                                                        
filebeat.inputs:
  # HAProxy log input
  - type: log
    enabled: true
    paths:
      - /var/log/remote_logs/*/haproxy.log
    fields_under_root: true
    fields:
      log_type: haproxy
    processors:
      - dissect:
          tokenizer: "%{haproxy.syslog_date} %{haproxy.syslog_time} %{haproxy.hostname} %{haproxy.program}: %{haproxy.client_ip}:%{haproxy.client_port} [%{haproxy.accept_date}] %{haproxy.frontend} %{haproxy.backend}/%{haproxy.server} %{ha>
          field: message
          target_prefix: parsed_haproxy
          ignore_failure: true

  # DNF log input
  - type: log
    enabled: true
    paths:
      - /var/log/remote_logs/*/dnf.log
    fields_under_root: true
    fields:
      log_type: dnf
    processors:
      - dissect:
          tokenizer: "%{dnf.syslog_date} %{dnf.syslog_time} %{dnf.hostname} %{dnf.program} %{dnf.timestamp} %{dnf.level} %{dnf.message}"
          field: message
          target_prefix: parsed_dnf
          ignore_failure: true

# Output to Elasticsearch
output.elasticsearch:
  hosts: ["http://localhost:9200"]
  index: "filebeat-%{+yyyy.MM.dd}"

# Template and Kibana dashboard setup
setup.template.name: "filebeat"
setup.template.pattern: "filebeat-*"
setup.kibana:
  host: "http://localhost:5601"
```
