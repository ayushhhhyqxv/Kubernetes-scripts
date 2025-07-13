kubectl run nginx --image=nginx:latest

kubectl get nodes

kubectl get pods

kubectl config view # will show config file clusters,context and user credentials

kubectl config get-contexts # shows all available contexts
  
openssl genrsa -out ayush.key 2048  # generates RSA key via ssl

openssl req -new -key ayush.key -out ayush.csr -subj "/CN=ayush/O=group1" # creates csr 

ls
# Must show this ayush.csr  ayush.key  filesystem

cat ayush.csr | base64 | tr -d "\n" # view the csr file in base64 encoded format !

vim csr.yaml
# ADD THE BELOW THING IN IT WITH CSR BASE 64 NUMBER IN 'REQUEST' PART
# apiVersion: certificates.k8s.io/v1
# kind: CertificateSigningRequest
# metadata:
#   name: ayush
# spec:
#   request: BASE64_CSR
#   signerName: kubernetes.io/kube-apiserver-client
#   usages:
#   - client auth

kubectl apply -f csr.yaml # certificate signing req is created

kubectl certificate approve ayush # certificate approved

kubectl get csr ayush -o jsonpath='{.status.certifica
te}' | base64 --decode > ayush.crt  # into CRT file

ls
# Must show this : ayush.crt  ayush.csr  ayush.key  csr.yaml  filesystem

cat << EOF | kubectl apply -f 

# kind: Role                     
# apiVersion: rbac.authorization.k8s.io/v1
# metadata:
#   namespace: default
#   name: pod-reader
# rules:
# - apiGroups: [""]
#   resources: ["pods"]
#   verbs: ["get", "watch", "list"]
# ---
# kind: RoleBinding
# apiVersion: rbac.authorization.k8s.io/v1
# metadata:
#   name: read-pods
#   namespace: default
# subjects:
# - kind: User
#   name: ayush  # mention user name correctly and give him his role/permission !
#   apiGroup: rbac.authorization.k8s.io
# roleRef:
#   kind: Role
#   name: pod-reader
#   apiGroup: rbac.authorization.k8s.io

> EOF

#role and rolebinding done 


kubectl config set-credentials ayush --client-certificate=ayush.crt --client-key=ayush.key 
# credentials and user setting

kubectl config set-context ayush-context --cluster=kubernetes --namespace=default --user=ayush
# context setting

kubectl config use-context ayush-context
# Switched to context "ayush-context"

kubectl config get-contexts
# WILL SHOW SMTHG LIKE THIS !
# CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
# *         ayush-context                 kubernetes   ayush              default
#           kubernetes-admin@kubernetes   kubernetes   kubernetes-admin   

cat ~/.kube/config # will show newly added user in it 

kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          25m
kubectl get deploy
Error from server (Forbidden): deployments.apps is forbidden: User "ayush" cannot list resource "deployments" in API group "apps" in the namespace "default"

# PROVES THAT USER CAN ONLY SEE AND CANT DEPLOY !

# NOW,ACCESSING KUBERNETES PROCESS DIRECTLY WITH API-calls,NO KUBECTL !
  
kubectl config use-context kubernetes-admin@kubernetes
# Switched to context "kubernetes-admin@kubernetes"

kubectl create serviceaccount sam --namespace default
# serviceaccount/sam created

kubectl create clusterrolebinding sam-clusteradmin-binding --clusterrole=cluster-admin--serviceaccount=default:sam


kubectl create token sam

TOKEN=<enter-token-value>

APISERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

curl -X GET $APISERVER/apis/apps/v1/namespaces/default/deployments -H "Authorization: Bearer $TOKEN" -k

create deployment nginx --image=nginx --dry-run=client -o json > deploy.json

curl -X POST $APISERVER/apis/apps/v1/namespaces/default/deployments \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -d @deploy.json \
  -k

kubectl get pods

# NAME                     READY   STATUS    RESTARTS   AGE
# nginx                    1/1     Running   0          49m
# nginx-5869d7778c-sspp9   1/1     Running   0          6s

# See your Nginx pod started without kubectl !
