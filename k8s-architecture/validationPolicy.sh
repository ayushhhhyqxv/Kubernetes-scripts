vi adm   
------>
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingAdmissionPolicy
metadata:
  name: "demo-policy.example.com"
spec:
  failurePolicy: Fail
  matchConstraints:
    resourceRules:
    - apiGroups:   ["apps"]
      apiVersions: ["v1"]
      operations:  ["CREATE", "UPDATE"]
      resources:   ["deployments"]
  validations:
    - expression: "object.spec.replicas <= 5"

---

apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingAdmissionPolicyBinding
metadata:
  name: "demo-binding-test.example.com"
spec:
  policyName: "demo-policy.example.com"
  validationActions: [Deny]
  matchResources:
    namespaceSelector:
      matchLabels:
        environment: test



kubectl apply -f adm

# validatingadmissionpolicy.admissionregistration.k8s.io/demo-policy.example.com created
# validatingadmissionpolicybinding.admissionregistration.k8s.io/demo-binding-test.example.com created

kubectl create deploy nginx --image=nginx --replicas=6

# error: failed to create deployment: deployments.apps "nginx" is forbidden: ValidatingAdmissionPolicy 'demo-policy.example.com' with binding 'demo-binding-test.example.com' denied request: failed expression: object.spec.replicas <= 5

# THIS ERROR SHOWS THE VALIDATION POLICY IS WORKING CORRECTLY !

