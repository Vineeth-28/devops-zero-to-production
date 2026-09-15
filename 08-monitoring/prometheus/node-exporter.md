# Node Exporter

## What it is
An official Prometheus exporter that exposes Linux/Unix host-level metrics
(CPU, memory, disk, filesystem, network) on `/metrics` for Prometheus to
scrape. It does not monitor applications — only the OS/host.

## Why we use it
Applications only expose their own business/HTTP metrics. Node Exporter
fills the gap for infrastructure-level visibility: is the underlying host
healthy, regardless of what's running on it?

## What it covers
- CPU: per-core usage, load average
- Memory: used, available, cached, swap
- Disk: I/O, space used/free per filesystem
- Filesystem: mount points, inode usage
- Network: bytes in/out per interface, errors, drops

## Mental model
```
Linux Server
    |
Node Exporter (listens on :9100)
    |
 /metrics
    |
Prometheus (scrapes on interval)
    |
Grafana (visualizes)
```

## Example scrape config
```yaml
scrape_configs:
  - job_name: "node"
    static_configs:
      - targets: ["10.0.1.10:9100"]
```

## Production use
- Deploy as a DaemonSet in Kubernetes so every node gets an instance
  automatically
- Combine with `kube-state-metrics` (cluster object state) and `cAdvisor`
  (per-container resource usage) for full Kubernetes observability — Node
  Exporter alone only covers the host, not containers or K8s objects

## Common mistakes
- Assuming Node Exporter gives you container-level metrics — it doesn't
  (that's cAdvisor's job)
- Not restricting Node Exporter's own resource footprint on constrained hosts

## Troubleshooting
- Target `up == 0` for a node job -> confirm Node Exporter process/pod is
  running and port 9100 is reachable (security group / NetworkPolicy)
- Missing filesystem metrics -> check mount point isn't excluded by
  Node Exporter's default collector filters

## Interview-ready answer
"Node Exporter is a Prometheus exporter that exposes host-level Linux
metrics — CPU, memory, disk, filesystem, and network — on a /metrics
endpoint. It's deployed alongside application instrumentation to give
infrastructure-level visibility, typically as a DaemonSet in Kubernetes so
every node is covered."
