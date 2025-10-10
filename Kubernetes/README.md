```

1. Re-Create - Delete Everything and Create New
2. Rolling Update (default) - Replace old pod with new pod
3. Blue Green Deployment - Have different version of pods and switch the traffic 100%
4. Canary Deployment - Have different version of pods and switch the traffic with incrementati basis
(Service Mesh)

Pod => Pod
ReplicaSet => ReplicaSet + Pod DeamonSet => DeamonSet + Pod
Deployment => Deployment + ReplicaSet + Pod

ClusterIp => ClusterIp
NodePort = NodePort + ClusterIp
LoadBalancer => LoadBalancer + NodePort + ClusterIp

```

```
Flow will be

Route53 -> LB -> Node port -> Cluster Ip -> Pod 
```
