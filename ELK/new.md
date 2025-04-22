```

# ============================== Filebeat Inputs ===============================

filebeat.inputs:

# 1. HAProxy log input (precise path)
- type: filestream
  enabled: true
  paths:
    - /var/log/remote_logs/myaccount-apilb-new/haproxy.log
  fields_under_root: true
  fields:
    log_type: generic
  processors:
    - dissect:
        tokenizer: "%{haproxy.syslog_date} %{haproxy.syslog_time} %{haproxy.hostname} %{haproxy.program}: %{haproxy.client_ip}:%{haproxy.client_port} [%{haproxy.accept_date}] %{haproxy.frontend} %{haproxy.backend}/%{haproxy.server} %{haproxy.Tq}/%{haproxy.Tw}/%{haproxy.Tc}/%{haproxy.Tr}/%{haproxy.Tt} %{haproxy.status_code} %{haproxy.bytes_read} %{haproxy.captured_request_cookie} %{haproxy.captured_response_cookie} %{haproxy.termination_state} %{haproxy.actconn}/%{haproxy.feconn}/%{haproxy.beconn}/%{haproxy.srv_conn}/%{haproxy.retries} %{haproxy.srv_queue}/%{haproxy.backend_queue} \"%{haproxy.http_request}\""
        field: message
        target_prefix: parsed_haproxy
        ignore_failure: true

    - rename:
        fields:
          - from: "parsed_haproxy.client_ip"
            to: "client.ip"
          - from: "parsed_haproxy.client_port"
            to: "client.port"
          - from: "parsed_haproxy.status_code"
            to: "http.response.status_code"
          - from: "parsed_haproxy.http_request"
            to: "http.request.line"
        ignore_missing: true

# 2. Catch-all fallback: multiline for other logs
- type: filestream
  id: fallback-filestream
  enabled: true
  paths:
    - /var/log/remote_logs/*/*.log
  exclude_files: ['haproxy.log']
  fields_under_root: true
  fields:
    log_type: raw
    source: "remote_logs"
  multiline.pattern: '^\d{4}-\d{2}-\d{2} '
  multiline.negate: true
  multiline.match: after

# ============================== Filebeat Modules ==============================

filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: false

# ======================= Elasticsearch Output Configuration ========================

output.elasticsearch:
  hosts: ["http://localhost:9200"]
  indices:
    - index: "myaccount_syslog-%{+yyyy.MM.dd}"
      when.contains:
        log_type: generic
    - index: "raw-logs-%{+yyyy.MM.dd}"
      when.contains:
        log_type: raw

# ============================== Setup Template =================================

setup.template.name: "myaccount_syslog"
setup.template.pattern: "myaccount_syslog-*"
setup.template.enabled: true

# ============================== Kibana =========================================

setup.kibana:
  host: "http://localhost:5601"

# ============================= Dashboards ======================================

setup.dashboards.enabled: true

# =========================== Logging ===========================================

logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat
  keepfiles: 7
  permissions: 0644





````
