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

#### Node & Pod Affinity, Anti-Affinity, Taints & Tolerations 

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
<img width="1588" height="1002" alt="image" src="https://github.com/user-attachments/assets/41f57d11-ca64-4f8d-89c3-286a010c6b9d" />

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

Ans : I’d label the second node with a custom label like node=second and then use a nodeAffinity rule under
requiredDuringSchedulingIgnoredDuringExecution in my Pod spec to match that label. 
This ensures Kubernetes only schedules the Pod or Deployment on node 2.

2. You have a Kubernetes cluster with 5 nodes and want to deploy an application with 3 replicas (Pods).
Each Pod must run on a different node so that no two Pods of the same application are scheduled on the same node.
How would you configure the Deployment to ensure high availability and proper Pod distribution across nodes?

Ans : I would use Pod Anti-Affinity in the Deployment spec with requiredDuringSchedulingIgnoredDuringExecution 
and topologyKey: kubernetes.io/hostname. This ensures that each Pod is scheduled on a different node, 
so no two Pods of the same application run on the same node, providing high availability across the cluster.
```
##### Master Persistent Volumes in Kubernetes 

```
Volume Types
- EmptyDir -> Temporary Storage
- hostPath -> Mount to host File System (Not Recommended)
- Persistent Volumes
Provisioning
- Static Provisioning
- Dynamic Provisioning
YAML
- Storage Class
- Persistent Volume
- Persistent Volume Claim
- Pod
```


