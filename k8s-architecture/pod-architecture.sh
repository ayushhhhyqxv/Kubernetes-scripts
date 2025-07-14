kubectl get nodes node01 -oyaml | grep CIDR 
// specifies CIDR port range for pods for manager/control plane !

kubectl run ayush --image nginx
kubectl get pods
kubectl describe pods
kubectl logs --ayush
kubectl logs ayush
kubectl pods -oyaml
   kubectl get pods -oyaml
    vim init.yaml
   kubectl apply init.yaml
   kubectl apply -f init.yaml
   kubectl get pods
   kubectl logs bootcamp-pod
   kubectl get pods 
   kubectl get pods -owide
   curl 192.168.1.5 
   vim multi.yaml
   kubectl apply -f multi.yaml
   kubectl describe pods
   vim service.yaml
   kubectl apply -f service.yaml
   kubectl get pods 
   kubectl describe pods
      
vim init.yaml # add the given init file,it runs before actual container starts


kubectl apply -f init.yaml

kubectl get pods

kubectl logs bootcamp-pod # pod-name within init file, timeline of logs


kubectl get pods 
# NAME           READY   STATUS    RESTARTS   AGE
# ayush          1/1     Running   0          20m
# bootcamp-pod   1/1     Running   0          96s
# only one pod is running because init container just fetching data then its task is completed !

kubectl get pods -owide


curl <ip-address> # will show your output now 

vim multi.yaml # example of multiple-int container

kubectl apply -f multi.yaml

kubectl describe pods # this container would not run as we didnt give service file which is required in that file therfore insead of crashing it did not intialize only !


vim service.yaml # add your file 

kubectl apply -f service.yaml

kubectl get pods 
# NAME           READY   STATUS    RESTARTS   AGE
# ayush          1/1     Running   0          27m
# bootcamp-pod   1/1     Running   0          8m50s
# init-demo-2    1/1     Running   0          71s

kubectl describe pods
# Now we will see both 0of our uninitialized container working , this is how we save pods crashing !
# One more method is there ie multi-containers in a pod,which has side car container as as which is used for connection of different containers in other pods also for authentication with the main container 

# issue which came in it is about what if main-container starts before our authentication pod then we can use initialize container like keep your authentication in initial container unless it is verified then only start main-container !

vim multicon.yaml

kubectl apply -f multicon.yaml

kubectl describe pods # first the initial container starts then our main one , this thing is called ambassador pattern which contains side car container !