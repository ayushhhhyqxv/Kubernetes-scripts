# Setting a priority of a pod such that it executes first even if others are scheduled in that run,even does eviction based on resources 

# Valid range: 0 to 1,000,000,000 (1 billion),for system critical priority pods values go up-to 2 billion !

kubectl create deploy nginx --image=nginx --replicas=110

# Now we evict some pods using this 

vi priority.yaml 
->
# apiVersion: scheduling.k8s.io/v1
# kind: PriorityClass
# metadata:
#   name: demo-priority
# value: 1000000
# globalDefault: false
# description: "This priority class should be used higher priority."

vi priority-pod.yaml
->
# apiVersion: v1
# kind: Pod
# metadata:
#   name: high-priority-pod
# spec:
#   priorityClassName: demo-priority
#   containers:
#   - name: busybox
#     image: busybox
#     command: ["sleep", "3600"]
#     resources:
#       requests:
#         cpu: "300m"
#         memory: "300Mi"

kubectl apply -f priority-pod.yaml

watch kubectl get pods -o wide  # High-priority Pod runs immediately; nginx Pods may stall

kubectl get pods -o wide --sort-by='{.spec.priority}'  # will show priority wise 

