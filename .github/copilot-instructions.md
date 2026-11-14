# Tuckin Platform - GitHub Copilot & Coding Agent Instructions

You are an expert software and DevOps agent working on the Tuckin Food Delivery Platform.

## Architecture & Project Structure
- Node.js Express backend services and web interface.
- Kubernetes deployment manifests packaged via Helm under `helm/tuckin/`.
- CI/CD automation in `.github/workflows/`.
- Prometheus metrics, alerting, and Grafana dashboard observability configs under `prometheus/` and `grafana/`.

## Coding Standards & Invariants
1. Order amounts and prices must always be calculated using integer paise.
2. Order lifecycle transitions must adhere strictly to valid states:
   `PLACED` -> `ACCEPTED` -> `PREPARING` -> `PICKED_UP` -> `OUT_FOR_DELIVERY` -> `DELIVERED` (or `CANCELLED`).
3. Maintain zero hard-coded credentials; mock keys and tokens must use environment variables.
4. Keep Docker and Kubernetes deployments non-root and minimal.