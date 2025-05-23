## ssh 
```
SELECT IPV4_SRC_ADDR AS src_ip, COUNT(*) AS flow_count
FROM flows
WHERE IP_DST_PORT = 22
  AND DST_ASN = 132420
  AND LAST_SEEN >= now() - INTERVAL 1 DAY
GROUP BY src_ip
ORDER BY flow_count DESC
FORMAT JSON;
```
