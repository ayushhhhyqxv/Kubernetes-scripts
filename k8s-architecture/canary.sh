# A canary deployment is a technique where you roll out a new version of your application to a small subset of users before rolling it out to everyone

vi canary-svc.yaml
->
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80

vi canary-deploy.yaml
->
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-stable
spec:
  replicas: 9
  selector:
    matchLabels:
      app: nginx
      version: "1.17"
  template:
    metadata:
      labels:
        app: nginx
        version: "1.17"
    spec:
      containers:
      - name: nginx
        image: nginx:1.17
        ports:
        - containerPort: 80

vi canary-deploy2.yaml
->
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
      version: "1.18"
  template:
    metadata:
      labels:
        app: nginx
        version: "1.18"
    spec:
      containers:
      - name: nginx
        image: nginx:1.18
        ports:
        - containerPort: 80

kubectl apply -f canary-svc.yaml

kubectl apply -f canary-deploy.yaml

kubectl apply -f canary-deploy2.yaml

kubectl get pods -o=custom-columns=NAME:.metadata.name,IMAGE:.spec.containers[*].image --watch

# 90% of users would use normal feature while update which is rolled out can only be used by 10% users

# But nowadays in this age practice its done with gateway API and service mesh !