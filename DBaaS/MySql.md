# Mysql / MariaDB Backend Architecture

```
                ┌────────────────────┐
                │     Public User    │
                │  (App / Customer)  │
                └─────────▲──────────┘
                          │
                          │ (Public IP / Domain e.g., e2e-81-70.ssdcloudindia.net)
                          ▼
                ┌───────────────────────┐
                │    MaxScale Node      │
                │───────────────────────│
                │ Public IP: 203.x.x.x  │  ◀── Client access
                │ Mgmt IP:  192.168.x.x │  ◀── Admin access
                │ Private IP: 10.0.x.x  │  ◀── DB node access
                └────┬─────────────┬────┘
                     │             │
        ┌────────────▼─┐       ┌───▼────────────┐
        │  Master DB   │       │  Replica DB 1  │
        │  10.0.0.11   │       │  10.0.0.12     │
        └──────────────┘       └────────────────┘

                         (More replicas optional)

```



# Command To Login 
```bash
mysql -h <host> -P 3306 -u <'username'> -p <'password'>
```

