#!/bin/sh




set -e



# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config

echo "========"
Namespace=$(find / -name namespace.yaml)
echo $Namespace
echo "========"
Deployment=$(find / -name deployment.yaml)
echo $Deployment
for deployment2 in $Deployment
do
    kubectl apply -f $deployment2
done
echo "========"


sh -c "kubectl get pods --all-namespaces"

