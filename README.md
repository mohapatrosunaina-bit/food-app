# MealTrail

**MealTrail** is a small food-ordering and delivery-tracking demo built to exercise the five DevOps phases in the supplied project brief. The customer website includes a browsable menu, cart, mock checkout, order tracking, and a restaurant kitchen view. Orders use trusted menu prices and integer paise; no real payment is taken.

## Run locally

Requires Node.js 20+. No npm packages are required.

```sh
npm start
# open http://localhost:3000
```

Run with Docker Compose using `docker compose up --build`; data persists in a named volume. Order data is stored in a JSON file for this demo. Replace it with PostgreSQL before using multiple replicas or production traffic.

## Phase 1 — Version control

- Keep changes small and require pull request review for pricing or total calculation changes.
- Tag production releases (`v1.0.0`, `v1.1.0`) so incidents map to an immutable image tag.
- Trunk-based workflow: short-lived branches, frequent merges to `main`, CI required before merge.

## Phase 2 — CI/CD

GitHub Actions runs tests, build checks, an 80% coverage gate, Docker build, and Trivy high/critical scan. A `v*` tag publishes a versioned GHCR image. The Helm chart uses NGINX Ingress canary weight 20 and a separately tagged image; this requires ingress-nginx. The canary image must implement the estimated delivery feature (25 minutes); stable defaults to 30. Roll back by setting `canary.enabled=false`.

## Phase 3 — Containerization

`Dockerfile` uses a minimal Node Alpine runtime and a non-root user. Start the app with Compose. Image build is part of CI and Trivy scans source and published images. Scan locally with `trivy image mealtrail:local` after building.

## Phase 4 — Orchestration

The Helm chart deploys the platform behind an Ingress, configures liveness/readiness probes, and sets an HPA on CPU. Use `values-dev.yaml`, `values-staging.yaml`, or `values-prod.yaml` for environment-specific host and capacity settings. Example:

```sh
kubectl create secret generic mealtrail-secrets -n mealtrail-dev --from-literal=payment-gateway-key=mock
helm upgrade --install mealtrail ./helm/mealtrail -n mealtrail-dev -f ./helm/mealtrail/values-dev.yaml --set image.repository=ghcr.io/OWNER/food-app --set image.tag=v1.0.0
```

The key is optional and mock-only. Use a secret manager for real credentials; never commit secret values. The sample app uses local JSON storage and is not horizontally safe: use shared PostgreSQL and persistent shared state before scaling replicas.

## Phase 5 — IaC, monitoring, and DevSecOps

- `terraform/` creates separate Kubernetes namespaces from environment `.tfvars.example` files; review `terraform plan` before any apply.
- `ansible/` installs a weekly scheduled cleanup for old delivery simulation logs (14-day retention).
- Prometheus scrapes `/metrics`; Grafana provisions a dashboard for order status, throughput, delivery time, and errors. Start the app with Compose, then run `docker compose -f docker-compose.yml -f docker-compose.observability.yml up --build`.
- Prometheus alerts when request failure rate exceeds 5% for 2 minutes. To demonstrate, generate invalid API requests, inspect the dashboard and alert in Prometheus at `http://localhost:9090/alerts`.
- `k6/order-flow.js` simulates a lunch spike and complete menu/order/track flow. Run `k6 run k6/order-flow.js`; preserve the result as `docs/LUNCH_SPIKE_REPORT.md` after executing on the target environment.

## Notes

This repo is a coursework demonstration, not a production payment or dispatch service. Delivery progression is simulated by restaurant staff through the kitchen view. Use GHCR package version tags for rollback; CI retains immutable version history. Change workflow action versions and pin to reviewed SHAs per your organization policy.
