
---

## 🔑 HAProxy Terminology Explained

| **Term**             | **Meaning**                                                                 |
|----------------------|------------------------------------------------------------------------------|
| **Frontend**         | Entry point of the traffic. Defines how requests come **in** to HAProxy.    |
| **Backend**          | Defines where HAProxy **forwards** the traffic. Usually one or more servers.|
| **Server**           | A real server inside a backend that handles the request.                    |
| **Listen**           | A combined frontend + backend block (less common, used in TCP setups).      |
| **ACL (Access Control List)** | Rules used to match traffic (e.g., URL path, IP, headers).          |
| **Stick Table**      | Used for session persistence (tracking users or IPs).                       |
| **Balance**          | Load-balancing method (e.g., `roundrobin`, `leastconn`, `source`).          |
| **Stats**            | Web dashboard to monitor HAProxy status and connections.                    |
| **Health Check**     | Automatically checks server availability using HTTP or TCP probes.          |
| **Timeouts**         | Defines how long to wait for various parts of a connection.                 |
| **Option httplog**   | Enables detailed logging of HTTP traffic.                                   |
| **Mode http/tcp**    | Defines if the proxy works on the **HTTP layer** or the **TCP layer**.      |
| **Stickiness**       | Ensures requests from the same user go to the same backend server.          |
| **Logging Facility** | Which syslog channel to use (`local0`, `local1`, etc).                      |

---

## 🖼️ Example Flow

```
Client --> [Frontend] --> ACL --> [Backend] --> [Server 1 / Server 2]
```

You can use ACLs to **route traffic** based on hostname, path, etc.

---

## ⚖️ Types of Load Balancing in HAProxy

| **Algorithm**       | **Description**                                                                 |
|---------------------|----------------------------------------------------------------------------------|
| **roundrobin**      | ✅ **Default.** Sends requests to servers in a circular order. Simple and fair. |
| **leastconn**       | Sends requests to the server with the **fewest active connections**.             |
| **source**          | Uses the **client IP hash** to always direct traffic to the same server (sticky).|
| **uri**             | Uses the **URI hash** to select a server, good for **cache-friendly** setups.   |
| **url_param**       | Balances based on a **query string parameter** in the URL.                      |
| **hdr(name)**       | Balances based on a specific **HTTP header**, like `User-Agent`.               |
| **rdp-cookie(name)**| Used in RDP protocols (sticky session via cookie).                              |
| **first** (TCP only)| Sends all connections to the **first healthy server** in the list.              |
| **random**          | Picks a server **at random**, optionally weighted.                              |

---

### 📝 Examples:

**1. Round Robin**
```haproxy
balance roundrobin
```

**2. Least Connections**
```haproxy
balance leastconn
```

**3. Sticky by IP**
```haproxy
balance source
```

**4. Sticky by URI**
```haproxy
balance uri
hash-type consistent
```

**5. Sticky by URL Parameter**
```haproxy
balance url_param sessionid
```

---

## 🤔 When to Use What?

| Use Case                               | Recommended Algorithm   |
|----------------------------------------|--------------------------|
| General purpose                        | `roundrobin`             |
| Uneven server capacities               | `leastconn`              |
| Sticky session (e.g., login session)   | `source` or `cookie`     |
| Cache optimization (CDN-style)         | `uri`                    |
| Load based on request header           | `hdr(User-Agent)`        |

---

list of use comands 
```
root@e2e-80-112:~# history
    1  sudo apt update && sudo apt upgrade -y
    2  curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic.gpg
    3  echo "deb [signed-by=/usr/share/keyrings/elastic.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
    4  sudo apt update
    5  sudo apt install elasticsearch
    6  sudo kill -9 2459
    7  sudo rm /var/lib/dpkg/lock-frontend
    8  sudo rm /var/cache/apt/archives/lock
    9  sudo dpkg --configure -a
   10  sudo kill -9 2459
   11  sudo rm /var/lib/dpkg/lock-frontend
   12  sudo rm /var/cache/apt/archives/lock
   13  sudo dpkg --configure -a
   14  sudo apt install elasticsearch
   15  echo -e "network.host: 0.0.0.0\ndiscovery.type: single-node" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
   16  sudo systemctl start elasticsearch
   17  sudo systemctl enable elasticsearch
   18  curl -X GET "localhost:9200"
   19  sudo apt install kibana
   20  sudo systemctl enable kibana
   21  sudo systemctl start kibana
   22  sudo apt install nginx -y
   23  sudo nano /etc/nginx/sites-available/your_domain
   24  sudo sed -i 's|#\?server.host:.*|server.host: "0.0.0.0"|' /etc/kibana/kibana.yml
   25  sudo systemctl restart kibana
   26  sudo ufw allow 5601/tcp && sudo ufw reload
   27  sudo systemctl enable kibana
   28  sudo nginx -t && sudo systemctl restart nginx
   29  sudo apt install filebeat
   30  sudo nano /etc/filebeat/filebeat.yml
   31  sudo filebeat modules enable system
   32  sudo filebeat setup --pipelines --modules system
   33  sudo filebeat setup --index-management -E output.elasticsearch.enabled=true -E 'output.elasticsearch.hosts=["localhost:9200"]'
   34  sudo filebeat setup -E output.elasticsearch.enabled=true -E 'output.elasticsearch.hosts=["localhost:9200"]' -E setup.kibana.host=localhost:5601
   35  sudo nano /etc/filebeat/filebeat.yml
   36  tail -f /var/log/haproxy.log
   37  sudo apt install haproxy
   38  tail -f /var/log/haproxy.log
   39  sudo apt update
   40  sudo apt install haproxy
   41  haproxy -v
   42  sudo nano /etc/haproxy/haproxy.cfg
   43  sudo nano /etc/haproxy/haproxy.cfg
   44  sudo systemctl restart haproxy
   45  sudo systemctl status haproxy.service
   46  sudo journalctl -xeu haproxy.service
   47  nano /var/log/haproxy.log
   48  cat /var/log/haproxy.log
   49  sudo apt update
   50  sudo apt install haproxy -y
   51  haproxy -v
   52  sudo nano /etc/haproxy/haproxy.cfg
   53  sudo systemctl restart haproxy
   54  sudo systemctl enable haproxy
   55  sudo nano /etc/rsyslog.d/49-haproxy.conf
   56  sudo systemctl restart rsyslog
   57  history
root@e2e-80-112:~# 
```
