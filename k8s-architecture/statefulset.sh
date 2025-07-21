# Statefulsets used with services for :
# Stable Hostnames: Each Pod gets a fixed DNS name (<name>-0, <name>-1).
# Persistent Storage: Volumes stick to Pods even after rescheduling.
# Ordered Scaling: Pods start/stop sequentially (0 → N-1).
# For Stateful Apps: Ideal for databases (MySQL, MongoDB) and distributed systems.

kubectl expose pod nginx --port 80 --dry-run=client -oyaml
->
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    run: nginx
status:
  loadBalancer: {}

kubectl expose pod nginx --port 80                        

kubectl get svc

# NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
# kubernetes   ClusterIP   10.96.0.1      <none>        443/TCP   47h
# nginx        ClusterIP   10.98.28.102   <none>        80/TCP    12s

curl 10.98.28.102 # traffic cannot access as right now ip is private ! it will display output for now

kubectl delete pods --all

vi statefulset.yaml
->
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: "postgres"
  replicas: 3
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:13
        ports:
        - containerPort: 5432
          name: postgres
        env:
        - name: POSTGRES_PASSWORD
          value: "example"
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:
  - metadata:
      name: postgres-storage
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi

vi svc.yaml
->
apiVersion: v1
kind: Service
metadata:
  name: postgres
  labels:
    app: postgres
spec:
  ports:
  - port: 5432
    name: postgres
  clusterIP: None  # Also called as Headless Service!
  selector:
    app: postgres



kubectl apply -f statefulset.yaml

kubectl apply -f svc.yaml

kubectl get pods -owide -w

# NAME         READY   STATUS    RESTARTS   AGE   IP            NODE     NOMINATED NODE   READINESS GATES
# postgres-0   1/1     Running   0          25s   192.168.1.6   node01   <none>           <none>
# postgres-1   1/1     Running   0          24s   192.168.0.5   controlplane   <none>           
# postgres-2   1/1     Running   0          5s    192.168.1.8   node01         <none>     


kubectl exec -it postgres-0 -- psql -U postgres  # Voila it starts running !

postgres=# exit          