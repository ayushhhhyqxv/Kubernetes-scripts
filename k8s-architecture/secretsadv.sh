# Data such as passwords and admin users name cannot be directly passed like config maps there comes secrets !

# FIRST WAY USING SSH ->
ssh-keygen

# Generating public/private ed25519 key pair.
# Enter file in which to save the key (/root/.ssh/id_ed25519): 
# Your identification has been saved in /root/.ssh/id_ed25519
# Your public key has been saved in /root/.ssh/id_ed25519.pub

kubectl create secret generic my-ssh-key-secret \
--from-file=ssh-privatekey=/root/.ssh/id_ed25519 \  #actually add location of ssh key location !
--type=kubernetes.io/ssh-auth

# secret/my-ssh-key-secret created

kubectl get secrets
# NAME                TYPE                     DATA   AGE
# my-ssh-key-secret   kubernetes.io/ssh-auth   1      12s

kubectl get secrets my-ssh-key-secret -oyaml

kubectl delete secrets my-ssh-key-secret     

secret "my-ssh-key-secret" deleted

# now using BASIC AUTH ->

kubectl create secret generic my-basic-auth-secret \
--from-literal=username=myuser \
--from-literal=password=mypassword \
--type=kubernetes.io/basic-auth

# secret/my-basic-auth-secret created

kubectl get secrets
# NAME                   TYPE                       DATA   AGE
# my-basic-auth-secret   kubernetes.io/basic-auth   2      15s

kubectl get secrets my-basic-auth-secret -oyaml
# apiVersion: v1
# data:
#   password: bXlwYXNzd29yZA==          # passwords are passed with base 64 encoding !
#   username: bXl1c2Vy
# kind: Secret
# metadata:
#   creationTimestamp: "2025-07-18T14:14:45Z"
#   name: my-basic-auth-secret
#   namespace: default
#   resourceVersion: "4455"
#   uid: c1c4252d-c450-4f78-98ab-ae0538edf0b9
# type: kubernetes.io/basic-auth

echo 'bXlwYXNzd29yZA==' | base64 -d  # it actually encodes within pods 

# lastly using SECRETS FILE ->

vim secrets.yaml 
->
apiVersion: v1
kind: Secret
metadata:
  name: my-opaque-secret
type: Opaque
data:
  password: c3VwZXJzZWNyZXQ=  # we need to pass base64 encoding only

# in real prod deployments various diff seal methods are used on top of this .

kubectl apply -f secrets.yaml


# USING CLI METHOD 

kubectl create secret generic mysql-root-pass --from-literal=password='abc123'
kubectl create secret generic mysql-user-pass --from-literal=password='test@123'

# passing using credentials in a pod 

vi pod.yaml
->
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
spec:
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:5.7
        env:
          - name: MYSQL_ROOT_PASSWORD
            valueFrom:
              secretKeyRef:
                name: mysql-root-pass
                key: password
          - name: MYSQL_PASSWORD
            valueFrom:
              secretKeyRef:
                name: mysql-user-pass
                key: password
        ports:
          - containerPort: 3306
        volumeMounts:
          - name: mysql-storage
            mountPath: /var/lib/mysql
      volumes:
        - name: mysql-storage
          emptyDir: {}

kubectl apply -f pod.yaml

kubectl -it <pod-name> -- mysql -u root -p  # will ask for password, voila you can now access sql !