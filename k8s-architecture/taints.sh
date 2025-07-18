# just opposite of affinity,taints and tolerations work together to repel Pods from Nodes or allow exceptions, ensuring Pods only run on appropriate Nodes

# tolerations is nothing but it is applied to Pods to allow them to run on tainted Nodes

kubectl taint nodes node01 app=demo:NoSchedule # tainting the node01

vi toleration.yaml
->
# apiVersion: v1
# kind: Pod
# metadata:
#   name: pod-with-tolerations
# spec:
#   containers:
#   - name: nginx
#     image: nginx
#   tolerations:
#   - key: "app"
#     operator: "Equal"
#     value: "demo"
#     effect: "NoSchedule"

kubectl apply -f toleration.yaml

kubectl get pods # you can see the toleration wala pod running 