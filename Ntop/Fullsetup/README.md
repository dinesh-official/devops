Perfect! Since your goal is to:

✅ Store **all flow data**  
✅ Use **ClickHouse** as the backend  
✅ Do **historical analysis** (weeks/months)  
✅ Get **deep filtering, dashboards, and GUI drill-downs**

---

### ✅ Best Version for You: **ntopng Enterprise M**

**Why Enterprise M?**  
It is:
- **Designed** for ClickHouse integration  
- Supports **unlimited flow exports**  
- Includes **advanced historical data access**  
- Allows per-host/protocol/port **filtering** in GUI  
- Comes with **API access**, **custom dashboards**, and **automation hooks**

---

### 📦 Version Recommendation

| Component        | Recommended Version         |
|------------------|-----------------------------|
| **ntopng**       | **Enterprise M 6.2+**        |
| **nprobe**       | Latest (optional, if NetFlow/IPFIX) |
| **ClickHouse**   | **v22.2+ or v23.3 LTS**      |
| **OS**           | Ubuntu 22.04 LTS (stable)    |

✅ The version you mentioned:
> `ntopng Community v.6.2.250403 (Ubuntu 22.04.4)`  
is **ok** for testing, but **not production-suitable** for flow history via ClickHouse.

---

### 🔐 Licensing

You can request an **Enterprise M trial** here:  
➡️ [https://shop.ntop.org/](https://shop.ntop.org/)

After getting the license, drop it into:
```bash
/etc/ntopng.license
```

---

### 🧰 Would You Like a Full Setup Script?

I can prepare a complete:
- ntopng Enterprise M installation
- ClickHouse integration
- GUI configuration
- Flow export setup

Let me know and I’ll generate it step by step for you.
