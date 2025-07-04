# Download Minikube for linux first

sudo usermod -a -G docker $USER && newgrp docker # Give permission to docker for driver 

minikube start --driver=docker

docker ps # Check whether minikube is running or not

minikube ssh

docker ps # check all the kubernetes services here,then exit 

sudo snap install kubectl --classic # snap is a tool to install containerized application

kubectl get pods # will show pods having default names

kubectl get nodes # will show nodes aligned

kubectl get pods --namespace=kube-system  # shows all k8s system pods

kubectl get namespaces  # would specify types of namespaces

kubectl create namespace <your-app-name>

# Check again it would be reflected ! 

# In order to create a pod, write a yaml file

# once done with yaml file then 

kubectl apply -f pod.yaml

kubectl get pods --namespace=<your-namespace>  # will show your running pod 

minikube ssh 

docker ps # can now see running your container

kubectl get po --namespace=<your-namespace> -o wide # get pods with specified namespace in wide output with IP

kubectl delete -f pod.yaml  # to delete the entire pod,it does not delete the file / we can even edit for now i am editing some changes 

# Adding more containers to a single pod 

# Further more add deployment file and replicas you want 

kubectl apply -f deployment.yaml

kubectl get pods --namespace=<your-namespace> # You can see your pods running along with replicas !

# Try auto heal thing 

kubectl delete pods <random-pod-name-and-id>

kubectl get pods --namespace=<your-namespace> # You will see your pod auto-heal and recreated

# To permanently delete your pod , delete the yaml file config ie 

kubectl delete -f deployment.yaml

# Check for pods again you wont find now !

