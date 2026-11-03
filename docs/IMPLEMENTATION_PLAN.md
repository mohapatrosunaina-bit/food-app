# Implementation plan

The brief has five phases. Each phase is represented by code or a repeatable deployment artifact in this repository.

1. **Version control:** trunk-based collaboration guidance, focused PR review for price/total logic, and semantic release tags.
2. **CI/CD:** GitHub Actions tests, coverage gate (80%), build, Trivy scanning, versioned GHCR publish; NGINX Ingress 20% canary and rollback instructions.
3. **Containerization:** minimal non-root Docker image and Docker Compose for app plus optional monitoring stack.
4. **Orchestration:** Helm deployment, service/Ingress, health probes, environment values, external secret reference, and CPU HPA.
5. **IaC, monitoring, DevSecOps:** Terraform namespace examples, Ansible scheduled log retention, Prometheus metrics/alerts, Grafana dashboard, and k6 lunch spike.

## Acceptance criteria

- Customer can browse menu, add items, place mock-paid order, and view status.
- Restaurant view lists orders and advances their status in sequence.
- Server computes integer paise totals from menu catalog; user input cannot set price.
- CI covers test, build, coverage threshold and Trivy scan.
- Compose, Helm environments, HPA, canary routing, Terraform, Ansible, Prometheus and Grafana configs are documented.
- No real payment credentials or production deploy are included.

## Known demonstration limits

Single-process JSON persistence supports a local demonstration only; HPA and multi-replica deployment need PostgreSQL/shared state. The canary chart demonstrates traffic splitting, but running it needs an ingress-nginx controller, two published tags and a Kubernetes cluster. The lunch report requires a real k6 run against the target environment.
