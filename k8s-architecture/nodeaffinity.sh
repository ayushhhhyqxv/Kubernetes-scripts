# Node affinity is a powerful Kubernetes feature that allows you to constrain which nodes your Pods can be scheduled on based on node labels. It better than node-selector approach 


vim node-affinity.yaml
->
# apiVersion: v1
# kind: Pod
# metadata:
#   name: mypod
# spec:
#   containers:
#   - name: mycontainer
#     image: nginx
#   affinity:
#     nodeAffinity:
#       requiredDuringSchedulingIgnoredDuringExecution:
#         nodeSelectorTerms:
#         - matchExpressions:
#           - key: "topology.kubernetes.io/region"
#             operator: In
#             values:
#             - "us-east-1"
#       preferredDuringSchedulingIgnoredDuringExecution:
#       - weight: 1
#         preference:
#           matchExpressions:
#           - key: "disktype"
#             operator: In
#             values:
#             - "ssd"

# compulsory add this pod in us-east-1 

# nodes in us-east-1 are considered,among us-east-1 nodes,those with disktype=ssd get higher priority,if no ssd nodes are available, schedules on any us-east-1 node,schedules on score given ie weight given

