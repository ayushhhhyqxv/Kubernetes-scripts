cat nginx-rs.yaml          # creation of replica set having 3 replicas!
->
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-rs
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80

# So we are experimenting how with the same label does the pod work in same replica set

cat pod-rs.yaml
->
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80

kubectl apply -f nginx-rs.yaml

kubectl get pods 

# NAME             READY   STATUS              RESTARTS   AGE
# nginx-rs-426gl   1/1     Running             0          7s
# nginx-rs-jdmxh   1/1     Running             0          7s
# nginx-rs-khqwr   0/1     ContainerCreating   0          7s

kubectl apply -f pod-rs.yaml

kubectl get pods -w
->
# NAME             READY   STATUS    RESTARTS   AGE
# nginx-rs-426gl   1/1     Running   0          31s
# nginx-rs-jdmxh   1/1     Running   0          31s
# nginx-rs-khqwr   1/1     Running   0          31s
# nginx-pod        0/1     Pending   0          0s
# nginx-pod        0/1     Pending   0          0s
# nginx-pod        0/1     Pending   0          0s
# nginx-pod        0/1     ContainerCreating   0          0s
# nginx-pod        0/1     Terminating         0          1s
# nginx-pod        0/1     ContainerStatusUnknown   0          2s
# nginx-pod        0/1     ContainerStatusUnknown   0          2s
# nginx-pod        0/1     ContainerStatusUnknown   0          2s

kubectl delete -f nginx-rs.yaml

# Now applying it vice versa ie first defining our single pod then its replica set

kubectl apply -f pod-rs.yaml

kubectl apply -f nginx-rs.yaml

kubectl get po # notice how its inserts our pod in replica set which was created with same label but separately
->
# NAME             READY   STATUS    RESTARTS   AGE
# nginx-pod        1/1     Running   0          46s
# nginx-rs-7qvns   1/1     Running   0          20s
# nginx-rs-nk95x   1/1     Running   0          20s

kubectl get rs

# NAME       DESIRED   CURRENT   READY   AGE
# nginx-rs   3         3         3       28s


# Roll-outs

kubectl create deploy bootcamp --image nginx --replicas 4 --port 80

kubectl rollout status deployment bootcamp # will show updates which was done latest and whether it is successfully done or not !

kubectl set image deploy bootcamp nginx=nginx:1.14.0 --record # Updating the image

kubectl rollout history deploy/bootcamp --revision=2 # will show updates history like git commits ! upto 2 roll-outs !

kubectl set image deploy bootcamp nginx=nginx:1.14.a --record # now again updating image !

kubectl rollout status deployment bootcamp # will show some error as my above image is not fetchable !

kubectl rollout undo deployment/bootcamp --to-revision=1 # undoing image changes as i wanted my previous version which was working up-to 1 place only







