# It ensures that the pod's network identity (IP address, etc.) remains consistent even if application containers within the pod are restarted or crash

# In Kubernetes when you launch a pod, there is also a pause container that gets spinned up

# Usually when container is restarted the IP of container changes however in K8S it is preserved by pause file !

# Go through an example of side care container !

vim deploy.yaml

kubectl apply -f deploy.yaml # input replica file

kubectl get pods 

# NAME                                READY   STATUS              RESTARTS   AGE
# nginx-deployment-647677fc66-j5gdc   0/1     ContainerCreating   0          7s
# nginx-deployment-647677fc66-rq6jw   0/1     ContainerCreating   0          7s
# nginx-deployment-647677fc66-x7whx   0/1     ContainerCreating   0          7s


vim pdb.yaml # Describe your pod disruption budget file 

kubectl apply -f pdb.yaml

kubectl get pdb

# NAME        MIN AVAILABLE   MAX UNAVAILABLE   ALLOWED DISRUPTIONS   AGE
# nginx-pdb   2               N/A               1                     12s

kubectl describe deploy

# Name:                   nginx-deployment
# Namespace:              default
# Labels:                 app=nginx
# Annotations:            deployment.kubernetes.io/revision: 1
# Selector:               app=nginx
# Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
# StrategyType:           RollingUpdate
# MinReadySeconds:        0
# RollingUpdateStrategy:  25% max unavailable, 25% max surge
# Pod Template:
#   Labels:  app=nginx
#   Containers:
# Conditions:
#   Type           Status  Reason
#   ----           ------  ------
#   Available      True    MinimumReplicasAvailable
#   Progressing    True    NewReplicaSetAvailable
# OldReplicaSets:  <none>
# NewReplicaSet:   nginx-deployment-647677fc66 (3/3 replicas created)
# Events:
#   Type    Reason             Age    From                   Message
#   ----    ------             ----   ----                   -------
#   Normal  ScalingReplicaSet  2m41s  deployment-controller  Scaled up replica set nginx-deployment-647677fc66 from 0 to 3

# The ROLLING UPDATE STRATEGY DESCRIBES HOW PODS WILL UPDATE WHEN WE UPDATE DEPLOY FILE ! EVEN REPLICAS SCALING IS MENTIONED STATUS WISE


kubectl set image deploy/nginx-deployment nginx=nginx:1.16.1 #   Updating the deploy file !


kubectl get pods -w
# THE HIERARCHY OF POD CREATION AFFTER UPDATE IE BAASED ON ROLLING STRATEGY !


# NAME                                READY   STATUS              RESTARTS   AGE
# nginx-deployment-647677fc66-j5gdc   1/1     Running             0          4m45s
# nginx-deployment-647677fc66-x7whx   1/1     Running             0          4m45s
# nginx-deployment-8d94c585f-gwm6t    1/1     Running             0          16s
# nginx-deployment-8d94c585f-shgsn    0/1     ContainerCreating   0          9s
# nginx-deployment-8d94c585f-shgsn    1/1     Running             0          13s
# nginx-deployment-647677fc66-j5gdc   1/1     Terminating         0          4m49s
# nginx-deployment-8d94c585f-mpqpn    0/1     Pending             0          0s
# nginx-deployment-8d94c585f-mpqpn    0/1     Pending             0          0s
# nginx-deployment-647677fc66-j5gdc   1/1     Terminating         0          4m49s
# nginx-deployment-647677fc66-j5gdc   0/1     Completed           0          4m50s
# nginx-deployment-647677fc66-j5gdc   0/1     Completed           0          4m50s
# nginx-deployment-647677fc66-j5gdc   0/1     Completed           0          4m50s
# nginx-deployment-8d94c585f-mpqpn    0/1     Pending             0          1s
# nginx-deployment-8d94c585f-mpqpn    1/1     Running             0          2s
# nginx-deployment-647677fc66-x7whx   1/1     Terminating         0          4m51s
# nginx-deployment-647677fc66-x7whx   1/1     Terminating         0          4m51s
# nginx-deployment-647677fc66-x7whx   0/1     Completed           0          4m51s
# nginx-deployment-647677fc66-x7whx   0/1     Completed           0          4m52s
# nginx-deployment-647677fc66-x7whx   0/1     Completed           0          4m52s


kubectl get pods 

# NAME                               READY   STATUS    RESTARTS   AGE
# nginx-deployment-8d94c585f-gwm6t   1/1     Running   0          74s
# nginx-deployment-8d94c585f-mpqpn   1/1     Running   0          54s
# nginx-deployment-8d94c585f-shgsn   1/1     Running   0          67s

# FINALLY THE UPDATED PODS ARE HERE WITHOUT GETTING DOWN ALL CONTAINERS IN SUDDEN !

vim pdb.yaml # TRY TO CHANGE PDB RULE set minimum disruption budget to zero

vim trydeploy.yaml # input the deploy file

kubectl apply -f trydeploy.yaml

kubectl apply -f pdb.yaml

kubectl set image deployment/nginx-deployment nginx=nginx:1.16.1 # Again updating with different pdb !

kubectl drain node01 --ignore-daemonsets

# Warning: ignoring DaemonSet-managed Pods: kube-system/canal-w7ggb, kube-system/kube-proxy-m46xg

# error when evicting pods/"nginx-deployment-8d94c585f-bmmsb" -n "default" (will retry after 5s): Cannot evict pod as it would violate the pod's disruption budget.

# node manager says it could not go forward now as pdb rule would get violate