# In Kubernetes, probes are health checks used to monitor the state of your containers. They help ensure your application is running correctly and can handle traffic

# startup probe -> Determines if a container has successfully started,used For slow-starting applications.

# liveness probe -> Checks if the container is still running properly,if it fails: Kubernetes kills the container and restarts it.

# readiness probe -> Checks if the container is ready to serve traffic.If it fails: The Pod is removed from service

vi probe.yaml  # here we are going liveness probe !
->
# apiVersion: v1
# kind: Pod
# metadata:
#   creationTimestamp: null
#   labels:
#     run: nginx
#   name: nginx
# spec:
#   containers:
#   - image: nginx
#     name: nginx
#     livenessProbe:
#       httpGet:
#         path: /
#         port: 80
#     ports:
#     - containerPort: 80
#     resources: {}
#   dnsPolicy: ClusterFirst
#   restartPolicy: Always
# status: {}

# BUT ACTUALLY ALL THREE KINDS OF PROBE ARE REQUIRE AND THEY WORK TOGETHER

# To have checks if the container is still running correctly after startup/initialization,if failed, Kubernetes restarts the container.
# if failed, the Pod is removed from service load balancers.
# determines if the container is ready to handle requests,If failed, the Pod is removed from Service load balancers 

vi probe-2.yaml
->
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2
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
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 15
          timeoutSeconds: 2
          periodSeconds: 5
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          timeoutSeconds: 2
          periodSeconds: 5
          successThreshold: 1
          failureThreshold: 3
        startupProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 5
          failureThreshold: 10

kubectl apply -f probe-2.yaml

kubectl get pods -w # watch them initialize 

kubectl delete -f probe-2.yaml

# How to check whether these checks are actually working 

# just change image of container (add smthg with would actually not work)

kubectl apply -f probe-2.yaml

kubectl get pods -w # now you can actually see how the checks are working 

# Something by default which k8s adds
# When pods are running check 

kubectl describe pods 
->
# Liveness:http-get http://:80/ delay=0s timeout=1s period=10s #success=1 #failure=3 

# after 3 failures k8s would restart container !
# delay,timeout and period is also set by default by k8s

