vi dynamic.yaml

cat dynamic.yaml
----->
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  ports:
  - port: 3306
    name: mysql
  clusterIP: None
  selector:
    app: mysql
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  serviceName: mysql
  replicas: 3
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
        image: mysql:8.0
        ports:
        - containerPort: 3306
          name: mysql
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "password"
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
  volumeClaimTemplates:
  - metadata:
      name: mysql-persistent-storage
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "local-path"
      resources:
        requests:
          storage: 10Gi


kubectl apply -f dynamic.yaml

kubectl get pvc  

kubectl get pv -w  # You will notice that pvc is first created and then automatically pv is created and automatically binded in dynamically!

kubectl delete sc local-path

kubectl delete pods --all --force

pod "mysql-0" force deleted
pod "mysql-1" force deleted
pod "mysql-2" force deleted

kubectl delete statefulset --all --force

kubectl delete pvc --all --force

kubectl delete pv --all --force

# Still PV remains even after deleting pvc if reclaim policy is retain !
