# Creation of dedicated namespace,not same as linux its used for grouping here 

kubectl get ns # 4 default namespaces you can see 

kubectl create ns dev  # dev dedicated namespace 

kubectl create ns bootcamp # bootcamp one 

kubectl create deploy demo -n bootcamp --image=nginx  # labelling with bootcamp namespace to this container !

kubectl create deploy demo -n dev --image=nginx  # to dev ns 

kubectl config set-context --current --namespace=dev # switching context from default namespace to dev ns , ie it will pods running in dev ns when get pods is asked ! 

# Resource quota and limit range 

# Resource quota is just like limit range for entire namespace , as limit range is only for containers 1

vi ResourceQuota.yaml 

vi limit-range.yaml

kubectl apply -f ResourceQuota.yaml 

kubectl apply -f limit-range.yaml

# Then try to run a container/namespace having resources more than specified , it wont run 

# Labels and Selectors  

kubectl run nginx --image nginx #

kubectl label pod nginx app=testing  # labelling above pod with key and value 

kubectl get pods nginx --show-labels # wil show above label ie testing 

# Set based 

kubectl get pod -l app!=nginx  # show pods which does not have key's value (label) as nginx

kubectl create deploy bootcamp --image=nginx --replicas 3 # by default label is set as DEPLOYMENT name 

kubectl get pods -l 'app in (test,bootcamp)'  # will show all 3 replicas with  bootcamp label !



