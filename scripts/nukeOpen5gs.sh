#!/usr/bin/env bash

# Setup custom root certificate for istio
# https://istio.io/latest/docs/tasks/security/cert-management/plugin-ca-cert/


kubectl label namespace open5gs istio-injection-
kubectl delete namespace istio-system

kubectl delete namespace open5gs
sleep 30
kubectl delete pv mongodb-pv-volume-open5gs
sleep 30

istioctl install --set profile=demo -y
kubectl create namespace open5gs
kubectl label namespace open5gs istio-injection=enabled

Hostname=$(hostname)
if [ "$Hostname" = "wabash" ] ; then
    cd /home/ukulkarn/opensource-5g-core/helm-chart/ 
else
    cd /opt/opensource-5g-core/helm-chart/ 
fi
helm -n open5gs install -f values.yaml 5gcore ./
sleep 10
kubectl config set-context --current --namespace=open5gs

# Enable mTLS strict mode
# https://istio.io/latest/docs/tasks/security/authentication/mtls-migration/#lock-down-to-mutual-tls-by-namespace
# In case we want to enable it globally - https://istio.io/latest/docs/tasks/security/authentication/authn-policy/#globally-enabling-istio-mutual-tls-in-strict-mode
kubectl apply -n open5gs -f - <<EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: "default"
spec:
  mtls:
    mode: STRICT
EOF

# Execute from AMF node:
# curl -v --request POST -d '{"ueLocation":{"nrLocation":{"tai":{"plmnId":{"mcc":"208","mnc":"93"},"tac":"000001"},"ncgi":{"plmnId":{"mcc":"208","mnc":"93"},"nrCellId":"000000010"},"ueLocationTimestamp":"2022-11-30T03:19:48.206301Z"}},"ueTimeZone":"-05:00"}' -H "Content-Type: application/json" --http2-prior-knowledge  -A "AMF" http://10.244.227.23/nsmf-pdusession/v1/sm-contexts/12/release

