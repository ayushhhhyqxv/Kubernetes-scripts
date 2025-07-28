kubectl get pods 

vi empty.yaml
---->
apiVersion: v1
kind: Pod
metadata:
  name: emptydir-pod
spec:
  containers:
    - name: busybox
      image: busybox
      command: ['sh', '-c', 'echo "Writing data to /data/emptydir-volume..."; echo "Hello" > /data/emptydir-volume/hello.txt; sleep 3600']
      volumeMounts:
        - name: temp-storage
          mountPath: /data/emptydir-volume
  volumes:
    - name: temp-storage
      emptyDir: {}


kubectl apply -f empty.yaml

kubectl get pods 

kubectl exec -it emptydir-pod -- sh

ls
# bin    data   dev    etc    home   lib    lib64  proc   root   sys    tmp    usr    var

cat /data/emptydir-volume/hello.txt
# Hello

kubectl get volumes


kubectl describe pod emptydir-pod

kubectl delete -f  empty.yaml

# This type pod is called temp-pod , whose data/volume is deleted within empty dir mounted when pod is deleted !

vi new.yaml # Giving limit of resources in temp pod example
--------->
apiVersion: v1
kind: Pod
metadata:
  name: emptydir-pod
spec:
  containers:
    - name: busybox
      image: busybox
      command: ['sh', '-c', 'echo "Writing data to /data/emptydir-volume..."; sleep 3600']
      volumeMounts:
        - name: temp-storage
          mountPath: /data/emptydir-volume
  volumes:
    - name: temp-storage
      emptyDir:
        medium: Memory
        sizeLimit: 512Mi

kubectl apply -f empty.yaml

kubectl describe emptydir-pod

kubectl get pods              

kubectl exec -it emptydir-pod -- df -h /data/emptydir-volume

kubectl describe pod emptydir-pod

kubectl describe pod emptydir-pod

vi host.yaml
------>
apiVersion: v1
kind: Pod
metadata:
  name: hostpath-pod
spec:
  containers:
    - name: busybox
      image: busybox
      command: ['sh', '-c', 'echo "Writing data to /data/hostpath-volume..."; echo "Hello " > /data/hostpath-volume/hello.txt; sleep 3600']
      volumeMounts:
        - name: host-storage
          mountPath: /data/hostpath-volume
  volumes:
    - name: host-storage
      hostPath:
        path: /tmp/hostpath
        type: DirectoryOrCreate

# HOST VOLUME means mounting volumes with hostpath's directory ie even pod is deleted the data is safe with host/node !

kubectl apply -f host.yaml

kubectl get pods 

# ONLY LINES TO FOCUS ON !

# NAME           READY   STATUS    RESTARTS   AGE
# emptydir-pod   1/1     Running   0          15m
# hostpath-pod   1/1     Running   0          9s

kubectl describe pods

# Mounts:
#   /data/hostpath-volume from host-storage (rw)
      

# Volumes:
#   host-storage:
#     Type:          HostPath (bare host directory volume)
#     Path:          /tmp/hostpath
#     HostPathType:  DirectoryOrCreate
  
# Events:
#   Type    Reason     Age   From               Message
#   ----    ------     ----  ----               -------
#   Normal  Scheduled  19s   default-scheduler  Successfully assigned default/hostpath-pod to node01
 
ssh node01 
# Since hostpath path is assigned on node01

ls 

cat /tmp/hostpath/hello.txt
# Hello !

exit
# Connection to node01 closed.

kubectl delete pod --all --force

# pod "emptydir-pod" force deleted
# pod "hostpath-pod" force deleted

ssh node01

cat /tmp/hostpath/hello.txt
# Hello !

# See Now you are able to retrieve data without worrying about pod deletion !