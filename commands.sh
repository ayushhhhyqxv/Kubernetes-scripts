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

kubectl delete pods <random-pod-name-and-id> -n <name-space-name>

kubectl get pods --namespace=<your-namespace> # You will see your pod auto-heal and recreated

# To permanently delete your pod , delete the yaml file config ie 

kubectl delete -f deployment.yaml

# Check for pods again you wont find now !

# To even manage deployment we have services such as cluster-IP and node PORT,here also labels and selectors play a vital role 

# Service creation converts all pods multiple IP's to a single IP

kubectl apply -f service.yaml

minikube service <service-name> -n <name-space> --url # Will get you all the URLS/Port related to that OR

kubectl get svc -n <name-space> # will show services in that specified name space

curl -L <url> # redirects to the url on which app is running ! 

# This whole setup is in local,to view on browser create ngrok account

# in your main server,create a directory for ngrok and inside that 
# install ngrok and authenticate yourself

ngrok http <url-of-service> # This creates a tunnel btw local and global and is represented on server shown ny ngrok

# Now comes ingress comes if you want to bind service to a domain

kubectl apply -f ingress.yaml

# Now for example i am binding clusterIP to service

sudo vim /etc/hosts # inside that bind 

<clusterIP> <domain-name/url-mentioned-in-service> # binds local cluster to global domain 

curl -L http://<domain-name/url-mentioned-in-service> 

# configMap starts 
# passing data from config file to pods (using ENV variables) to reduce its memory dependency and security features as well 

# create your configMap file then configure-pod file

kubectl apply -f configure-pod.yaml

kubectl get pods # will show your pod running too

kubectl exec it <pod-name> -- /bin/sh

echo $<env-name-corresponding-to-key>  # values are passed as env variables !

printenv # will show your key variable defined in configMap ! then exit 

# while kubectl get pods if "createConfigErrorOccurs" then delete and again create pods

# further i have mounted volume to pod of configMap incase i want to pass file instead of variable

kubectl apply -f configure-pod.yaml

kubectl exec it <pod-name> -- /bin/sh

ls # will show config path

cd config 

ls

cat level.properties # now you can see the data of configMap in pod due to mounting 

# for persistentVolume we will use mySQL

# Kubernetes finds storage matching "mysql-data-disk"

# It connects this storage to your container

# MySQL writes/fetches all its data to this storage instead of temporary container storage

# Even if the container dies, the data stays safe!

kubectl apply -f secrets.yaml  

kubectl apply -f persistentVolume.yaml

kubectl get persistentVolume.yaml # will show its properties 

kubectl apply -f deploymentwithPV.yaml

# Finally 

kubectl get pods 

kubectl apply -f service-SQL.yaml 

kubectl get svc # check its status

kubectl get deployments # check deployment status

kubectl get secrets # check if all of them are UP !

minikube service service-SQL # will show its data,access URL 

# first we need a client to access this sql server

apt-get install mysql-client

mysql -u root -p -h <your-IP-except_PORT_NUMBER> -P 30036  # enter the password followed in secret file






