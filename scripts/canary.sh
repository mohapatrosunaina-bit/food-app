#!/usr/bin/env bash
set -euo pipefail
NAMESPACE="${NAMESPACE:-mealtrail}"
RELEASE="${RELEASE:-mealtrail}"
CHART="${CHART:-./helm/mealtrail}"
IMAGE_REPOSITORY="${IMAGE_REPOSITORY:?Set IMAGE_REPOSITORY to a published image}"
STABLE_TAG="${STABLE_TAG:?Set STABLE_TAG to a stable release tag}"
CANARY_TAG="${CANARY_TAG:?Set CANARY_TAG to a canary release tag}"
helm upgrade --install "$RELEASE" "$CHART" -n "$NAMESPACE" --create-namespace \
  --set image.repository="$IMAGE_REPOSITORY" --set image.tag="$STABLE_TAG" \
  --set canary.enabled=true --set canary.weight=20 \
  --set canary.image.repository="$IMAGE_REPOSITORY" --set canary.image.tag="$CANARY_TAG"
echo 'Observe ingress, deployments, Prometheus error rate and order throughput.'
echo 'Rollback: helm upgrade "$RELEASE" "$CHART" -n "$NAMESPACE" --reuse-values --set canary.enabled=false'
