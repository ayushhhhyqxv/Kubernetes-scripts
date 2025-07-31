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



