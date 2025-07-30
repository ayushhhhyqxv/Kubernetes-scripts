# Local volumes with PersistentVolumeClaims are not automatically deleted when a host is deleted. Instead, the reclaim policy of the PersistentVolume determines what happens to the underlying storage,if the reclaim policy is set to Retain, the data remains on the disk, and manual intervention is needed to reclaim the storage. If the reclaim policy is Delete, the PV will be deleted along with the PVC

ls
#  README.md   dynamic-provisioning.yaml   emptyDIR2   emptyDir.yaml   hostpath.yaml  'local volume'   nfs

cd 'local volume'

kubectl apply -f sc.yaml

kubectl apply -f pv.yaml

kubectl apply -f pvc.yaml

kubectl get pvc

# NAME           STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS    VOLUMEATTRIBUTESCLASS   AGE
# demo-pvclaim   Pending                                      local-storage   <unset>                 5s

# Will not Bound until a pod is created,it wont use memory unless pod is initiated,waiting for user will be shown when we use "kubectl get sc" !

kubectl apply -f pod.yaml

kubectl get pods

kubectl get pvc

# NAME           STATUS   VOLUME    CAPACITY   ACCESS MODES   STORAGECLASS    VOLUMEATTRIBUTESCLASS   AGE
# demo-pvclaim   Bound    demo-pv   5Gi        RWO            local-storage   <unset>                 87s
