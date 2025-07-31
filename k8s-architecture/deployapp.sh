# Deploy a python app ! 


requirements.txt
+---------->
Flask
psycopg2-binary
gunicorn


Dockerfile 
+--------->
# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
COPY requirements.txt /app/

# Install any dependencies specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container at /app
COPY . /app

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable for Flask
ENV FLASK_APP=app.py

# Run the application using Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]

docker build --no-cache --platform=linux/amd64 -t ttl.sh/saiyam/demo:10h .  

docker push ttl.sh/saiyam/demo:10h 

# since we have DB in this app we we will use DB of postgreSQL IN KUBERNETES,  ie which is CRD(Custom resource definition) created on base layer of K8S,but modified fro postgreSQL !
# CLOUD NATIVE PG ie postgreSQL cluster 

kubectl apply --server-side -f \
  https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.23/releases/cnpg-1.23.1.yaml


vi postgres-cluster.yaml
+------->
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: my-postgresql
  namespace: default
spec:
  instances: 3
  storage:
    size: 1Gi
  bootstrap:
    initdb:
      database: goals_database
      owner: goals_user
      secret:
        name: my-postgresql-credentials

# Creation of secret for passing 

kubectl create secret generic my-postgresql-credentials --from-literal=password='new_password'  --from-literal=username='goals_user'  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f postgres-cluster.yaml 

kubectl get cluster # Must show your postgres cluster !

kubectl exec -it my-postgresql-1 -- psql -U postgres -c "ALTER USER goals_user WITH PASSWORD 'new_password';" # getting inside a instance of postgres out of 3

kubectl port-forward my-postgresql-1 5432:5432

PGPASSWORD='new_password' psql -h 127.0.0.1 -U goals_user -d goals_database -c "
CREATE TABLE goals (
    id SERIAL PRIMARY KEY,
    goal_name VARCHAR(255) NOT NULL
);
"

vi deploy.yaml
+------------->
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: ttl.sh/kubesimplify/app:10h
        imagePullPolicy: Always
        env:
        - name: DB_USERNAME
          valueFrom:
            secretKeyRef:
              name: my-postgresql-credentials
              key: username
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: my-postgresql-credentials
              key: password
        - name: DB_HOST
          value: my-postgresql-rw.default.svc.cluster.local
        - name: DB_PORT
          value: "5432"
        - name: DB_NAME
          value: goals_database
        ports:
        - containerPort: 8080
        readinessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 20
        resources:
          requests:
            memory: "350Mi"
            cpu: "250m"
          limits:
            memory: "500Mi"
            cpu: "500m"

kubectl apply -f deploy.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.4/deploy/static/provider/cloud/deploy.yaml 

# Downloading ingress controller for load balancer  !

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.5/cert-manager.yaml

# Downloading cert manager for secure connection !

kubectl get pods -A 

# Note the IP of ingress controller , since we have to deploy for public 
# Specify that IP to our domain name in Google Domain

vi ingress.yaml
+------>
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  annotations:
    cert-manager.io/cluster-issuer: production-app

spec:
  ingressClassName: nginx
  rules:
  - host: demo.kubesimplify.com  # host your domain name not IP
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app-service
            port:
              number: 80
  tls:
  - hosts:
    - demo.kubesimplify.com
    secretName: app

# if you dont have Domain we can use

demo.<ingress-controller-IP>.nip.io

kubectl get crd # cert manager's cluster issuer

vi cluster-issuer.yaml
+----------->
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: production-app
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: demo@v1.com
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: app 
    # Enable the HTTP-01 challenge provider
    solvers:
    - http01:
        ingress:
          class: nginx

kubectl apply -f cluster-issuer.yaml

vi certificate.yaml
+------------->
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: app
spec:
  secretName: app
  issuerRef:
    name: production-app
    kind: ClusterIssuer
  commonName: demo.kubesimplify.com
  dnsNames:
  - demo.kubesimplify.com

kubectl apply -f certificate.yaml

kubectl get certificate -oyaml  # shows true, if not check for errors using

kubectl get challenges 

kubectl get clusterissuer -oyaml

kubectl apply -f ingress.yaml

kubectl get ingress 

# PVC is automatically created by postgres-cluster ! 

# Now go to domain we can access the app

# scaling our deployment HPA(horizontal pod autoscaler)

vi horizontal.yaml
+----------->
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 20
  - type: Resource
    resource:
      name: memory
      target:
        type: AverageValue
        averageValue: 350Mi

kubectl apply -f horizontal.yaml

# Now load testing using k6 

vi load.js
+---------->
  import http from "k6/http";
  import { check } from "k6";


  export const options = {
    vus: 100,
    duration: '30s',
  };

  const BASE_URL = 'https://demo.kubesimplify.com'

  function demo() {
    const url = `${BASE_URL}`;


    let resp = http.get(url);

    check(resp, {
      'endpoint was successful': (resp) => {
        if (resp.status === 200) {
          console.log(`PASS! url`)
          return true
        } else {
          console.error(`FAIL! status-code: ${resp.status}`)
          return false
        }
      }
    });
  }

  export default function () {
      demo()
  }

k6s run load.js 
# keep watch on pods you will see horizontal scaling as specified





