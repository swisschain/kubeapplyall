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
    if [ -e namespace.yaml ]
    then
       kubectl apply -f namespace.yaml
    fi
   echo "--------------------------"
done

for main_directory in $path/*/
do
    cd $main_directory
    current_directory=${PWD##*/}
    echo "--------------------------"
    if [ -e configmap.yaml ]
    then
       kubectl apply -f configmap.yaml
    fi
    if [ -e secret.yaml ]
    then
       kubectl apply -f secret.yaml
    fi
    if [ -e service.yaml ]
    then
       kubectl apply -f service.yaml
    fi
    if [ -e deployment.yaml ]
    then
       kubectl apply -f deployment.yaml
    fi
    echo "--------------------------"
done

sh -c "kubectl get pods --all-namespaces"

