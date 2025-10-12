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

#### Node & Pod Affinity, Anti-Affinity, Taints & Tolerations Part-5 | DevOps | Ft. Greens technologies

```
Node
 - Node Selector
 - Node affinity  
 - Taint & Toleration
Pod
 - Pod affinity
 - Pod anti affinity
```
##### Node affinity 
```
Node affinity
 - Required Schedule
 - Prefered Schedule
```
##### Taint & Toleration
```
Taint Effects
 - NoSchedule
 - NoExecute
 - PreferNoSchedule
```
```
1. General Pod
2. General Pod (affinity: high-cpu, required during scheduling)
3. General Pod (affinity: high-cpu, preferred during scheduling)
4. General Pod (tolerations: Colour: Green)
5. General Pod (tolerations: Colour: Green, Colour: Blue)


```
##### Interview Questions
```
1. You have a 3-node cluster and want your Pod (or Deployment) to run only on node 2.

Ans : “I’d label the second node with a custom label like node=second and then use a nodeAffinity rule under
requiredDuringSchedulingIgnoredDuringExecution in my Pod spec to match that label. 
This ensures Kubernetes only schedules the Pod or Deployment on node 2.”
```


