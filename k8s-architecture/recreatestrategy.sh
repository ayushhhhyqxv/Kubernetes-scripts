# Instead of roll back strategy, this strategy completely recreates and kills the previous running pods when updated !

vi recreate.yaml 
->
# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: demo-deployment
# spec:
#   replicas: 3
#   strategy:
#     type: Recreate
#   selector:
#     matchLabels:
#       app: demo
#   template:
#     metadata:
#       labels:
#         app: demo
#     spec:
#       containers:
#       - name: demo
#         image: nginx:latest
#         ports:
#         - containerPort: 80

kubectl apply -f recreate.yaml 

kubectl set image deploy/demo-deployment demo=nginx:14.0 

kubectl get pods -w 

# all previous pods having earlier update getting terminated and new ones getting created leading to little downtime on large scale !