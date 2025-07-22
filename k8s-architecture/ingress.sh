# Directory structure shows different Kubernetes networking components
ExternalDNS  ExternalName  Headless  Ingress  README.md

# Changing to Ingress directory
cd Ingress

# Viewing files in the Ingress directory
ls
# Contains: deploy.yaml (nginx deployment), ingress.yaml (ingress rules), 
# nginx.conf (custom nginx config), svc.yaml (service definition)

# Viewing custom nginx configuration
cat nginx.conf
# This config:
# 1. Sets up basic nginx server listening on port 80
# 2. Defines two locations:
#    - / : Serves default nginx content from /usr/share/nginx/html
#    - /public : Returns a custom message 'Access to public granted!'
# 3. Includes standard logging and error handling

# Viewing Ingress resource definition
cat ingress.yaml
# This Ingress:
# 1. Uses nginx ingress class
# 2. Routes traffic for host "kubernetes.hindi.bootcamp"
# 3. Has two path rules:
#    - / : Routes to nginx-service on port 80
#    - /public : Also routes to nginx-service on port 80

# Installing Ingress Controller (nginx)
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/cloud/deploy.yaml
# This sets up:
# - Nginx ingress controller deployment
# - Required services (including LoadBalancer)
# - RBAC roles and config

# Creating ConfigMap from nginx configuration
kubectl create configmap nginx-config --from-file=nginx.conf
# Stores our custom nginx config to be mounted in the pod

# Viewing Deployment definition
cat deploy.yaml
# This:
# 1. Creates an nginx deployment with 1 replica
# 2. Mounts our custom nginx config (from ConfigMap) overwriting the default
# 3. Exposes port 80

# Viewing Service definition
cat svc.yaml
# Creates a ClusterIP service:
# - Named nginx-service
# - Exposing port 80
# - Targeting port 80 on pods with app: nginx label

# Applying deployment and service
kubectl apply -f deploy.yaml
kubectl apply -f svc.yaml

# Checking services
kubectl get svc
# Shows:
# - kubernetes (default service)
# - nginx-service (our service) with ClusterIP 10.108.37.121

# Testing service directly
curl 10.108.37.121
# Returns default nginx welcome page (from our custom config)

curl 10.108.37.121/public
# Returns our custom message 'Access to public granted!'

# Setting up local DNS (for testing)
vi /etc/hosts
# Need to add entry like:
# <ingress-controller-ip> kubernetes.hindi.bootcamp

# Applying Ingress rules
kubectl apply -f ingress.yaml

# Checking Ingress
kubectl get ing
# Shows our bootcamp ingress with host kubernetes.bootcamp

# Checking all services
kubectl get svc -A
# Important notes:
# 1. ingress-nginx-controller is of type LoadBalancer (but shows <pending> if no cloud provider)
# 2. It exposes ports:
#    - 80:32189 (NodePort mapping)
#    - 443:31225 (NodePort mapping)

# Testing through Ingress (using NodePort directly)
curl kubernetes.hindi.bootcamp:32189
# Should return default nginx page (routed through Ingress)

curl kubernetes.hindi.bootcamp:32189/public
# Should return 'Access to public granted!' (routed through Ingress)


# Flow of architecture here works as :

---------->

# User Request
#        ↓
# [Hosts file maps kubernetes.hindi.bootcamp to Ingress Controller IP]
#        ↓
# Ingress Controller (LoadBalancer Service: ingress-nginx-controller)
#        ↓
# Evaluates Ingress Rules (bootcamp ingress)
#        ↓
# Routes based on host (kubernetes.hindi.bootcamp) and path (/ or /public)
#        ↓
# Forwards to nginx-service (ClusterIP: 10.108.37.121)
#        ↓
# Reaches nginx pods running with custom configuration