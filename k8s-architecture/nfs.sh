# NFS (Network File System) storage in Kubernetes volumes refers to the use of an existing NFS share as a persistent storage solution for your Kubernetes pods. its like a remote storage for pods/cluster just like gluster,even if cluster is deleted then too our data remains with us

kubectl get nodes -owide

# node01         Ready    <none>          10d   v1.33.2   172.30.2.2    <none>        Ubuntu 24.04.1 LTS   6.8.

# Note the IP of node01 

ls

# README.md                   emptyDIR2       hostpath.yaml   nfs
# dynamic-provisioning.yaml   emptyDir.yaml  'local volume'

cd nfs

ls

# README.md  pod.yaml  pv.yaml  pvc.yaml

cat pv.yaml  # Add NFS server IP in this file to bound with NFS , here I have used node01's IP .
+-------------->
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  nfs:
    path: /srv/nfs/kubedata
    server: <NFS_SERVER_IP> # Add Here !
  persistentVolumeReclaimPolicy: Retain

vi pv.yaml

kubectl delete sc local-path # Else it would use local-path sc instead of our NFS !

# storageclass.storage.k8s.io "local-path" deleted

kubectl create -f pv.yaml

kubectl create -f pvc.yaml

kubectl get pvc

# NAME      STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
# nfs-pvc   Bound    nfs-pv   1Gi        RWX                           <unset>                 4s

# Read,Write,Execute with Bound Status is confirmed !

kubectl apply -f pod.yaml
pod/nfs-pod created
kubectl get pods 

# IN NODE01,for accessing our NFS data !

ssh node01

# Downloading NFS server here !

node01:~$ sudo apt update
sudo apt install -y nfs-kernel-server
sudo apt update
sudo apt install -y nfs-kernel-server

#Exporting Directory!

sudo mkdir -p /srv/nfs/kubedata
sudo chown nobody:nogroup /srv/nfs/kubedata
sudo chmod 777 /srv/nfs/kubedata

echo "/srv/nfs/kubedata *(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports

sudo exportfs -rav

sudo systemctl restart nfs-kernel-server

cd /srv/nfs/kubedata  # The Directory which is mounted for NFS !

ls  

# hello.txt  # Required File
