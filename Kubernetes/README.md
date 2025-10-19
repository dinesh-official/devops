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

#### Node & Pod Affinity, Anti-Affinity, Taints & Tolerations Part 5

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
#### Master Persistent Volumes in Kubernetes Part 6

```
Volume Types
 - EmptyDir -> Temporary Storage
 - hostPath -> Mount to host File System (Not Recommended)
 - Persistent Volumes
   - EBS
   - EFS
Provisioning
 - Static Provisioning
 - Dynamic Provisioning
YAML
 - Storage Class
 - Persistent Volume
 - Persistent Volume Claim
 - Pod
Access Modes
 - ReadWriteOnce (RWO) -› One node can read/write at a time (EBS)
 - ReadOnlyMany (ROX) -> Many nodes can read, but not write (EFS)
 - ReadWriteMany (RWX) -> Many nodes can read/write simultaneously (EFS)
Reclaim Policy
 - Retain -- manual reclamation
 - Recycle -- basic scrub (rm -rf /thevolume/*)
 - Delete -- delete the volume
--- Doc
• RWO - ReadWriteOnce
• ROX - ReadOnlyMany
• RWX - ReadWriteMany
• RWOP - ReadWriteOncePod
```

#### Master Config map, Secrets, Liveness, Readiness & Probes - Part 7 
```
Probes:
  Startup Probe
  Liveness Probe
  Readiness Probe

initialDelaySeconds: 15  (inital starting time)
periodSeconds: 30        (30 sec once it will check )
failureThreshold: 4      (if 4 times failed it will marked as failed)
successThreshold: 2      (if 2 time sucess it will marked as sucess )
timeoutSeconds: 10       (after check the resonce need to get within 10 sec )

I
2:00:00 PM
2:00:15 PM First Check (within 10 seconds give a response, Fail)
2:00:45 PM Second Check (within 10 seconds give a response, Fail)
2:01:15 PM Third Check (within 10 seconds give a response, Fail)
2:01:45 PM Fourth Check (within 10 seconds give a response, Fail)
2:02:15 PM Fifth Check (within 10 seconds give a response, Sucess)
2:02:45 PM Sixth Check (within 10 seconds give a response, sucess)

---

init Container - Setup/validation tasks before app starts
sidecar Container - Shared tasks like logging, proxy, monitoring
static Container - Managed by Kubelet not Api Server
ephemeral Container - Temporary debugging, troubleshooting

```
<img width="2126" height="1020" alt="image" src="https://github.com/user-attachments/assets/33893a32-0426-45ca-9f37-a55fad8daaeb" />

Kubernetes StatefulSets, Jobs, CronJobs, HPA & VPA

```
Job -> Pod (Short Lived Pod)
CronJob -> Job - > Pod (Short Lived Pod)
```

<img width="1153" height="529" alt="image" src="https://github.com/user-attachments/assets/c7ed62aa-5117-4851-92ef-5fc1524e5a03" />


```
Pods
Job
CronJob
ReplicaSet
DaemonSet
Deployment

StatefulSet
Clusterlp NodePort
LoadBalancer
Headless Service
ExternalName
```


```
Day 9
Job
CronJob
Statefulset
Headless Service
External Name Service
Request & Limit
HPA VPA
Troubleshooting Issue in Kubernetes

Day 10 (Finale)
CSI CNI CRI
Network Policy & Pod Security policy kubectl drain & Cordon
Security Context ?
What is Custom Resource Definition ?
Operators
Revise & Future !

Additionals
Helm Chart
Kustomize
Argo CD
Service Mesh ISTIO

```

```
CNI -> VPC CNI (Flannel, Calico)
CSI -> EFS CSI, EBS CSI
CRI -> ContinerD

Open Container Image (OCI) - Compliant Container Images

Docker
ContinerD
PODman
CRI-O


Network Policy
Pod Security Policy (PSP) -> Pod Security Admission


====

Pod Disruption Budget -> 2 POD
Kubectl drain ‹node> -> Evict all pods from the node
kubectl cordon <node> -› This makes the node as un-schedulable
kubectl uncordon <node> -› This makes the node as schedulable

Upgrading your kubernetes cluster.
1. Backup Everything
2. Read the Release Notes
3. Do the upgrading in Staging
4. Pod Distrubtion Budget
5. Control Plane Upgrade
6. New Worker Nodes compatible with 1.33
7. cordon & drain the old nodes to reschedule pods to new node group
8. Upgrade the add on version


HIGHLY IMPORTANT:
What is Liveness, Readiness, Startup Probes ?
What is Kubernetes Architecture ? Explain each component UseCases How do you Troubleshoot Kubernetes pods ?
- https://learnk8s.io/troubleshooting-deployments
What are the different services within Kubernetes?
What is an Ingress Controller (AWS Load Balancer As Ingress Controller)
(AWS Load
What is helm Charts in k8 / Helm Commands?

====================================================================

FREQUENTLY ASKED:
What is Container Network Interface (CNI) and CSI (Container Storage Interface) and Cont
Interface (CRI) ?
kubernetes imperative way (using CLI) vs declarative way (writing as YAML)
Life Cycle of Pod ?
What is Monolithic vs Microservice ?
Why Kubernetes?
Ways of Installation Kubernetes ?
Kubernetes Namespaces / What are default NameSpaces ?
Replica Set Yaml file ?
Deamon set Yaml file ?
Stateful Set yaml file?
Deployment yaml file ?
Replication Controller yaml file?
HPA -> Hortizonal Pod Autoscaling vs VPA Vertical Pod Autoscaling
Deployment Strategies ?
Blue Green Deployment in Kubernetes
НАоМ мхія
kind: pod vs deployment
Job vs CronJob ?
Nodeport Yaml file?
Cluster IP Yaml file?
LoadBalancer Yaml File?
Env Variables yaml file
Config Map yaml file
Secrets yaml file
Volumes yaml file
Persistent Volume yaml file
What is a Namespace in Kubernetes? Name the initial namespaces from which Kubernetes starts ?
What is the syntax for the Kubectl command?
What is a Headless Service?
What is a init container, and what would you use it for?
What is a sidecar container, and what would you use it for?
What is a Ephemeral container, and what would you use it for?
What are the Selector labels in Kubernetes?
What is Request & Limit to PODS / how to Assign CPU & Memory Resources to Container ?
What is ContainerPort, Port, NodePort, TargetPort ?
How Kubernetes Schedular Decides in Which Node to Schedule the POD ?
Explain Affinity and Anti-Affinity ?
Explain Taint & Tolerations ?
What do you mean by Persistent Volume ?
What do you mean by Persistent Volume Claim?
What are the access modes of Persistent Volume?
What are the Reclaim policy available in Persistent Volumes
What is kubectl drain?
What is Network Policy is Kubernetes/ how do you Restrict Pod to Pod Communication in ku
What is POD Security Policy is Kubernetes ?
What is Custom Resource Definition ?
What is RBAC ?
What is Role and RoleBinding RBAC ?
What is ClusterRole and ClusterRole Binding in RBAC ?
What is Service Account in RBAC ?

```
