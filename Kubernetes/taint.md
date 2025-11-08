# Equal 



| **Node Taint**              | **Pod Toleration (Equal)**                      | **Result**                    | **Explanation**                      |
| --------------------------- | ----------------------------------------------- | ----------------------------- | ------------------------------------ |
| `node=red:NoSchedule`       | `key=node, value=red, effect=NoSchedule`        | ✅ Pod runs                    | Key, value, effect all match         |
| `node=red:NoSchedule`       | `key=node, value=red, effect=PreferNoSchedule`  | ❌ Not scheduled               | Effect mismatch (strict NoSchedule)  |
| `node=red:NoSchedule`       | `key=node, value=red, effect=NoExecute`         | ❌ Not scheduled               | Effect mismatch                      |
| `node=red:NoSchedule`       | `key=node, value=blue, effect=NoSchedule`       | ❌ Not scheduled               | Value mismatch                       |
| `node=red:PreferNoSchedule` | `key=node, value=red, effect=PreferNoSchedule`  | ✅ Pod runs                    | Soft match — tolerated               |
| `node=red:PreferNoSchedule` | `key=node, value=red, effect=NoSchedule`        | ⚠️ May run                    | Soft taint ignored if no better node |
| `node=red:PreferNoSchedule` | `key=node, value=red, effect=NoExecute`         | ⚠️ May run, may get evicted   | NoExecute effect mismatch            |
| `node=red:PreferNoSchedule` | `key=node, value=blue, effect=PreferNoSchedule` | ❌ Not scheduled               | Value mismatch                       |
| `node=red:NoExecute`        | `key=node, value=red, effect=NoExecute`         | ✅ Runs & stays                | Full match of key + value + effect   |
| `node=red:NoExecute`        | `key=node, value=red, effect=NoSchedule`        | ⚠️ May start but then evicted | Effect mismatch (NoExecute taint)    |
| `node=red:NoExecute`        | `key=node, value=red, effect=PreferNoSchedule`  | ⚠️ May start but then evicted | Soft toleration ignored              |
| `node=red:NoExecute`        | `key=node, value=blue, effect=NoExecute`        | ❌ Not scheduled               | Value mismatch                       |





# Exist


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
