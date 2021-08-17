#!/bin/bash

# exit when any command fails
#set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config
find /|grep kubectl
kubectl version
kubectl config current-context
kubectl get nodes
ls -la
Namespace=$(find . -name "namespace*"|grep -v prod)
Configmap=$(find . -name "configmap*.yaml"|grep -v prod)
Secret=$(find . -name secret.yaml|grep -v prod)
Deployment=$(find . -name deployment.yaml|grep -v prod)
Service=$(find . -name service.yaml|grep -v prod)
RBAC=$(find . -name rbac.yaml|grep -v prod)

for namespace in $Namespace
do
    kubectl apply -f $namespace
done

for configmap in $Configmap
do
    kubectl apply -f $configmap
done

for secret in $Secret
do
    kubectl apply -f $secret
done

for deployment in $Deployment
do
    kubectl apply -f $deployment
done

for service in $Service
do
    kubectl apply -f $service
done

for rbac in $RBAC
do
    kubectl apply -f $rbac
done

rm /tmp/config
