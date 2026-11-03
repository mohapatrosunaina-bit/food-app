# Lunch-hour load report

Run `k6 run k6/order-flow.js` against the intended environment with `BASE_URL` set. The scenario ramps from 2 to 80 virtual users over the simulated lunch period, places and tracks orders, then ramps down. It checks for less than 5% failed requests and p95 latency under 1 second.

| Measure | Result |
|---|---|
| Target environment / date | Not run yet |
| Peak virtual users | 80 configured |
| Requests per second | Pending run |
| p95 latency | Pending run |
| Failed request rate | Pending run |
| HPA minimum / peak / final replicas | Pending cluster observation |

Do not present configured thresholds as measured results. Attach the k6 summary and Kubernetes replica observations after the run.
