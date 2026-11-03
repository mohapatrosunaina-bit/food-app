import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';
export const options = { scenarios: { lunch_spike: { executor: 'ramping-vus', startVUs: 2, stages: [{duration:'1m',target:10},{duration:'2m',target:30},{duration:'5m',target:80},{duration:'2m',target:10},{duration:'1m',target:0}] } }, thresholds: { http_req_failed: ['rate<0.05'], http_req_duration: ['p(95)<1000'] } };
const errors = new Rate('order_flow_errors');
const deliveryTime = new Trend('simulated_delivery_estimate_minutes');
const base = __ENV.BASE_URL || 'http://localhost:3000';
export default function () {
  const menuRes = http.get(`${base}/api/menu`);
  let ok = check(menuRes, {'menu available': r => r.status === 200});
  if (!ok) { errors.add(1); return; }
  const menu = menuRes.json();
  const res = http.post(`${base}/api/orders`, JSON.stringify({customerName:`Load ${__VU}`,items:[{id:menu[0].id,quantity:1}]}), {headers:{'Content-Type':'application/json'}});
  ok = check(res, {'order placed': r => r.status === 201}); errors.add(ok ? 0 : 1);
  if (ok) { const order = res.json(); deliveryTime.add(order.estimatedDeliveryMinutes); check(http.get(`${base}/api/orders/${order.id}`), {'order trackable': r => r.status === 200 && r.json('status') === 'PLACED'}); }
  sleep(1);
}
