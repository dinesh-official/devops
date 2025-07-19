## connect to clickhouse db
```
clickhouse-client --host 216.48.176.80 --port 9000 --user default
```


## ssh 
```sql
SELECT IPV4_SRC_ADDR AS src_ip, COUNT(*) AS flow_count
FROM flows
WHERE IP_DST_PORT = 22
  AND DST_ASN = 132420
  AND LAST_SEEN >= now() - INTERVAL 1 DAY
GROUP BY src_ip
ORDER BY flow_count DESC
FORMAT JSON;
```
with some filter 
```sql
SELECT
    IPv4NumToString(IPV4_SRC_ADDR) AS src_ip,
    COUNT(*) AS flow_count
FROM ntopng.flows
WHERE IP_DST_PORT = 22
  AND DST_ASN = 132420
  AND LAST_SEEN >= now() - INTERVAL 1 HOUR
GROUP BY src_ip
HAVING flow_count > 50
ORDER BY flow_count DESC
FORMAT JSON;
```
Bandwidth 
```sql
SELECT 
    IPv4NumToString(IPV4_SRC_ADDR) AS src_ip, 
    DST_ASN, 
    SUM(TOTAL_BYTES) AS total_bytes, 
    ROUND(SUM(TOTAL_BYTES) / 1024 / 1024, 2) AS total_mb
FROM ntopng.flows 
WHERE LAST_SEEN >= (now() - toIntervalDay(1)) 
  AND DST_ASN = 132420
GROUP BY src_ip, DST_ASN
HAVING total_bytes > 1048576
ORDER BY total_bytes DESC
FORMAT JSON;

```

outbound 
```sql
SELECT 
    IPv4NumToString(IPV4_SRC_ADDR) AS client_ip,
    COUNT(*) AS OB_Count,
    COUNT(DISTINCT IPV4_DST_ADDR) AS unique_server_ips,
    groupArray(DISTINCT IP_DST_PORT) AS destination_ports
FROM ntopng.flows
WHERE 
    DST_ASN != 132420
    AND SRC_ASN = 132420
    AND LAST_SEEN >= now() - INTERVAL 1 HOUR
GROUP BY IPV4_SRC_ADDR
ORDER BY 
    unique_server_ips DESC,  
    OB_Count DESC             
LIMIT 100;
```


outbount with filtered port
```sql

WITH 22 AS filter_port

SELECT 
    IPv4NumToString(IPV4_SRC_ADDR) AS client_ip,
    COUNT(*) AS OB_Count,
    COUNT(DISTINCT IPV4_DST_ADDR) AS unique_server_ips,
    groupArray(DISTINCT IP_DST_PORT) AS destination_ports
FROM ntopng.flows
WHERE 
    DST_ASN != 132420
    AND SRC_ASN = 132420
    AND LAST_SEEN >= now() - INTERVAL 10000 HOUR
    AND (filter_port = 0 OR IP_DST_PORT = filter_port)
GROUP BY IPV4_SRC_ADDR
ORDER BY 
    unique_server_ips DESC,  
    OB_Count DESC
LIMIT 100;
```



Open Ports 
```sql
SELECT
    IPv4NumToString(IPV4_DST_ADDR) AS ip,
    COUNT(*) AS incoming_request_count,
    COUNT(DISTINCT IPV4_SRC_ADDR) AS unique_source_ips
FROM ntopng.flows
WHERE DST_ASN = 132420
  AND IP_DST_PORT = 22
  AND LAST_SEEN >= now() - INTERVAL 24 HOUR  -- Change interval as needed
GROUP BY IPV4_DST_ADDR
HAVING incoming_request_count > 0
ORDER BY incoming_request_count DESC
LIMIT 10  -- Change as needed
FORMAT JSON;
```
