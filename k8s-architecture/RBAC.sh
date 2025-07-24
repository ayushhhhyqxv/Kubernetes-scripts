# RBAC is a security method where access to systems or data is given based on a persons job rolenot their individual identity.

ls  # must have files for RBAC 

deploy  rb  rb1  role  role2  sa

cat sa
----->
      apiVersion: v1
      kind: ServiceAccount
      metadata:
        name: deployment-manager
    
kubectl create sa deployment-manager

cat role
------>
      apiVersion: rbac.authorization.k8s.io/v1
      kind: Role
      metadata:
        namespace: default
        name: deployment-creator
      rules:
      - apiGroups: ["apps"]
        resources: ["deployments"]
        verbs: ["create", "delete", "get", "list", "patch", "update", "watch"]
  
kubectl apply -f role

# since deployment has permissions to create , pod runs with help of it in case of YAML file, as we have as same service account as superset, but the pod wont run with CLI commands  !



cat rb
------>
      apiVersion: rbac.authorization.k8s.io/v1
      kind: RoleBinding
      metadata:
        name: deployment-manager-binding
        namespace: default
      subjects:
      - kind: ServiceAccount
        name: deployment-manager
        namespace: default
      roleRef:
        kind: Role
        name: deployment-creator
        apiGroup: rbac.authorization.k8s.io
  
kubectl apply -f rb

kubectl get role 

# NAME                 
# deployment-creator   


kubectl run nginx --image=nginx --as=system:serviceaccount:default:deployment-manager 

# Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:default:deployment-manager" cannot create resource "pods" in API group "" in the namespace "default"

# See as permissions are not there the pod wont run , but incase of YAML file for creation of pod , deployment role whom we gave permission to create, creates the pod in this case then !
