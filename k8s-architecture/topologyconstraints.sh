these constraints control how Pods are spread across your cluster among failure-domains like Nodes (kubernetes.io/hostname) or regions or availability zones 

vi topology.yaml
->
# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: demo-app
# spec:
#   replicas: 4
#   selector:
#     matchLabels:
#       app: demo-app
#   template:
#     metadata:
#       labels:
#         app: demo-app
#     spec:
#       containers:
#       - name: app-container
#         image: nginx
#       topologySpreadConstraints:
#       - maxSkew: 1             # will scale up at max one container on the specified nod, or will evenly distribute if all nodes are allowed !
#         topologyKey: "kubernetes.io/hostname"
#         whenUnsatisfiable: DoNotSchedule
#         labelSelector:
#           matchLabels:
#             app: demo-app

kubectl scale deploy demo-app --replicas 6

kubectl cordon controlplane  # now not allowing to scale in control plane 

kubectl scale  deploy demo-app --replicas 7 # will scale up in node01 only 