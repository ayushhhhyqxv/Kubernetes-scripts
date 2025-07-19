cat cm1.yaml
->
apiVersion: v1
kind: ConfigMap
metadata:
  name: bootcamp-configmap
data:
  username: "ayush"
  database_name: "exampledb"

# Passing key values in pod now 

cat pod1.yaml
->
apiVersion: v1
kind: Pod
metadata:
  name: mysql-pod
spec:
  containers:
  - name: mysql
    image: mysql:5.7
    env:
      - name: MYSQL_USER
        valueFrom:
          configMapKeyRef:
            name: bootcamp-configmap
            key: username
      - name: MYSQL_DATABASE
        valueFrom:
          configMapKeyRef:
            name: bootcamp-configmap
            key: database_name
      - name: MYSQL_PASSWORD
        value: demo123  
      - name: MYSQL_ROOT_PASSWORD
        value: demo345 
    ports:
      - containerPort: 3306
        name: mysql
    volumeMounts:
      - name: mysql-storage
        mountPath: /var/lib/mysql
  volumes:
    - name: mysql-storage
      emptyDir: {}

kubectl apply -f cm1.yaml

kubectl apply -f pod1.yaml

kubectl get pods 
# NAME        READY   STATUS    RESTARTS   AGE
# mysql-pod   1/1     Running   0          4

kubectl exec -it mysql-pod -- mysql -u root -p

mysql> show databases 

mysql> SELECT user FROM mysql.user;  # THE SAME USER WHICH WE DEFINED IN CONFIG FILE
+---------------+
| user          |
+---------------+
| root          |
| ayush         |
| mysql.session |
| mysql.sys     |
| root          |
+---------------+

# passing file type data in config file
cat cm2.yaml
->
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: app-config-dev
  data:
    settings.properties: |
      # Development Configuration
      debug=true
      database_url=http://dev-db.example.com
      featureX_enabled=false

  ---

  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: app-config-prod
  data:
    settings.properties: |
      # Production Configuration
      debug=false
      database_url=http://prod-db.example.com
      featureX_enabled=true


cat pod2.yaml
->
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: my-web-app
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: my-web-app
    template:
      metadata:
        labels:
          app: my-web-app
      spec:
        containers:
        - name: web-app-container
          image: nginx  
          ports:
          - containerPort: 80
          env:
          - name: ENVIRONMENT
            value: "development"  
          volumeMounts:
          - name: config-volume
            mountPath: /etc/config
        volumes:
        - name: config-volume
          configMap:
            name: app-config-dev 

kubectl apply -f cm2.yaml

kubectl apply -f pod2.yaml

kubectl get pods 

# my-web-app-867c9b49df-kmn4s   1/1     Running   0          101s

kubectl exec -it my-web-app-867c9b49df-kmn4s -- cat /etc/config/settings.properties

# Development Configuration
debug=true
database_url=http://dev-db.example.com
featureX_enabled=false

# within pod's container we can access our passed file data !