| **Node Taint**              | **Pod Toleration (Exists)**                          | **Result**                      | **Explanation**                                      |
| --------------------------- | ---------------------------------------------------- | ------------------------------- | ---------------------------------------------------- |
| `node=red:NoSchedule`       | `key=node, operator=Exists, effect=NoSchedule`       | ✅ Pod runs                      | Key exists & effect matches                          |
| `node=red:NoSchedule`       | `key=node, operator=Exists, effect=PreferNoSchedule` | ❌ Not scheduled                 | Effect mismatch                                      |
| `node=red:NoSchedule`       | `key=node, operator=Exists, effect=NoExecute`        | ❌ Not scheduled                 | Effect mismatch                                      |
| `node=red:PreferNoSchedule` | `key=node, operator=Exists, effect=PreferNoSchedule` | ✅ Pod runs                      | Soft match — tolerated                               |
| `node=red:PreferNoSchedule` | `key=node, operator=Exists, effect=NoSchedule`       | ⚠️ May run                      | Soft taint ignored if no better node                 |
| `node=red:PreferNoSchedule` | `key=node, operator=Exists, effect=NoExecute`        | ⚠️ May run, but may get evicted | NoExecute effect mismatch, pod tolerated temporarily |
| `node=red:NoExecute`        | `key=node, operator=Exists, effect=NoExecute`        | ✅ Runs & stays                  | Full match of key + effect                           |
| `node=red:NoExecute`        | `key=node, operator=Exists, effect=NoSchedule`       | ⚠️ May start but then evicted   | Effect mismatch (NoExecute taint not tolerated)      |
| `node=red:NoExecute`        | `key=node, operator=Exists, effect=PreferNoSchedule` | ⚠️ May start but then evicted   | Effect mismatch (soft toleration ignored)            |
