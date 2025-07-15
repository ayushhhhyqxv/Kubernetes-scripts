vim limitrange.yaml # specifying limit and range of cpu and memory for a container 

kubectl apply -f limitrange.yaml

kubectl get limitrange     




kubectl run nginx --image=nginx 

kubectl describe pods

# Limits:
# cpu:     300m
# memory:  200Mi
# Requests:
# cpu:        200m
# memory:     100Mi
    
#OR
 
kubectl get pods -oyaml


    #   resources:
    #     limits:
    #       cpu: 300m
    #       memory: 200Mi
    #     requests:
    #       cpu: 200m
    #       memory: 100Mi
      
    # - allocatedResources:
    #     cpu: 200m
    #     memory: 100Mi
      
    #   resources:
    #     limits:
    #       cpu: 300m
    #       memory: 200Mi
    #     requests:
    #       cpu: 200m
    #       memory: 100Mi
      
    # qosClass: Burstable




# Burstable and Guaranteed are two Quality of Service (QoS) classes assigned to Pods based on their CPU/memory requests and limits.

# Guaranteed QOS : Pods with equal requests and limits for both CPU and memory.(HIGHEST PRIORITY)

# Burstable QOS : Pods with requests < limits (or only requests defined, but no limits) (MEDIUM PRIORITY)

# BestEffort QOS : Pods without any requests or limits,First ones to get killed when pods run low on resources 

# In first two you would find its specification in resources option as well as alloted resources but there is nothing in besteffort QOS 

#using downwardAPI for getting pods details itself 

vim downward.yaml

kubectl apply -f downward.yaml

 kubectl exec -it nginx-envars-fieldref -- printenv # will show pod related details 