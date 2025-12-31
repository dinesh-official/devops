# CORE SRE CONCEPTS

## 1. What is Site Reliability Engineering (SRE)?
**Answer:**  
SRE is a discipline that applies software engineering principles to operations to build reliable, scalable systems using automation.

## 2. How is SRE different from DevOps?
**Answer:**  
DevOps focuses on collaboration and delivery, while SRE focuses on reliability, SLIs, SLOs, and error budgets using engineering practices.

## 3. What are SLIs, SLOs, and SLAs?
**Answer:**  
- **SLI:** Metric that measures reliability (latency, error rate)  
- **SLO:** Target value for an SLI  
- **SLA:** Contractual guarantee with penalties  

## 4. What is an error budget?
**Answer:**  
The acceptable amount of failure allowed before reliability work is prioritized over new features.

---

# INCIDENT MANAGEMENT (VERY IMPORTANT)

## 5. How do you handle a production incident?
**Answer:**  
Acknowledge → Mitigate → Communicate → Fix → RCA → Prevent recurrence.

## 6. What is RCA?
**Answer:**  
Root Cause Analysis identifies why an incident happened and how to prevent it.

## 7. What metrics do you monitor?
**Answer:**  
Latency, error rate, traffic, saturation (the four golden signals).

## 8. What is on-call rotation?
**Answer:**  
A scheduled system where engineers respond to production alerts 24×7.

---

# KUBERNETES FOR SRE

## 9. How do you troubleshoot CrashLoopBackOff?
**Answer:**  
Check pod logs, events, environment variables, and resource limits.

## 10. What causes OOMKilled?
**Answer:**  
Container exceeds memory limits and is terminated by the kernel.

## 11. How do you ensure high availability in Kubernetes?
**Answer:**  
Using replicas, readiness probes, pod disruption budgets, and multi-AZ nodes.

## 12. What is liveness vs readiness probe?
**Answer:**  
Liveness checks if the app is alive; readiness checks if it can receive traffic.

---

# MONITORING & ALERTING

## 13. What tools have you used?
**Answer:**  
Prometheus, Grafana, CloudWatch.

## 14. What is alert fatigue?
**Answer:**  
Too many alerts causing important ones to be ignored.

## 15. How do you design good alerts?
**Answer:**  
Alert on user impact, not individual metrics.

---

# AUTOMATION & CI/CD

## 16. Why is automation important in SRE?
**Answer:**  
To reduce manual work, minimize errors, and improve reliability.

## 17. How do you automate infrastructure?
**Answer:**  
Using Infrastructure as Code tools like Terraform and CI/CD pipelines.

## 18. What happens if a deployment fails?
**Answer:**  
Rollback to the last stable version and investigate root cause.

---

# CLOUD & NETWORKING

## 19. What is multi-AZ architecture?
**Answer:**  
Deploying systems across multiple availability zones for fault tolerance.

## 20. What is load balancing?
**Answer:**  
Distributing traffic across multiple servers to ensure availability.

## 21. Difference between TCP and UDP?
**Answer:**  
TCP is reliable and connection-oriented; UDP is faster but unreliable.

---

# SRE BEHAVIORAL QUESTIONS

## 22. How do you handle pressure during outages?
**Answer:**  
Stay calm, prioritize user impact, communicate clearly, and fix systematically.

## 23. What would you do if the same incident happens again?
**Answer:**  
Implement automation or architectural changes to prevent recurrence.

## 24. Why do you want to be an SRE?
**Answer:**  
I enjoy solving production problems and improving system reliability using engineering approaches.

## 25. How do you balance reliability vs new features?
**Answer:**  
Using error budgets to decide when to focus on reliability or feature development.
