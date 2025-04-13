
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

If you're working on a specific project, I can suggest which one is best for your use case. Want to go into sticky sessions next?
