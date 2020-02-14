#!/bin/sh

set -e

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config

path=$(pwd)
for main_directory in $path/*/
do
    cd $main_directory
    current_directory=${PWD##*/}
    echo "--------------------------"
    kubectl apply -f namespace.yaml
    echo "--------------------------"
done

for main_directory in $path/*/
do
    cd $main_directory
    current_directory=${PWD##*/}
    echo "--------------------------"
    kubectl apply -f configmap.yaml
    kubectl apply -f secret.yaml
    kubectl apply -f service.yaml
    kubectl apply -f deployment.yaml
    echo "--------------------------"
done

sh -c "kubectl get pods --all-namespaces"

