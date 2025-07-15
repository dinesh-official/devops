```

               ┌────────────┐
               │  Customer  │
               └─────┬──────┘
                     │
              ┌──────▼──────┐
              │  MaxScale   │
              └────┬──┬─────┘
                   │  │
          ┌────────▼  ▼────────┐
          │    Master DB       │
          │   (Read/Write)     │
          └────────┬───────────┘
                   │
       ┌───────────▼───────────┐
       │     Replica DBs       │
       │   (Read-only nodes)   │
       └───────────────────────┘


    
```

```
                ┌────────────────────┐
                │     Public User    │
                │  (App / Customer)  │
                └─────────▲──────────┘
                          │
                          │ (Public IP / Domain e.g., dbproxy.example.com)
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
