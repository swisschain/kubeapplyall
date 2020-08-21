#!/bin/bash

# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config

kubectl config current-context
kubectl get nodes

Namespace=$(find Kubernetes -name "namespace*")
Configmap=$(find Kubernetes -name "configmap*")
Secret=$(find Kubernetes -name secret.yaml)
Deployment=$(find Kubernetes -name deployment.yaml)
Service=$(find Kubernetes -name service.yaml)
RBAC=$(find /Kubernetes -name rbac.yaml)

for yaml in $Namespace
do
    kubectl apply -f $yaml
done

for yaml in $Configmap
do
    kubectl apply -f $yaml
done

for yaml in $Secret
do
    kubectl apply -f $yaml
done

for yaml in $Deployment
do
    kubectl apply -f $yaml
done

for yaml in $Service
do
    kubectl apply -f $yaml
done

for yaml in $RBAC
do
    kubectl apply -f $yaml
done

rm /tmp/config
