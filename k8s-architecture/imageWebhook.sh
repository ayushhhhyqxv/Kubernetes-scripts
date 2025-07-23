# Kubernetes Validating admission policy setup and example 

vi adm
----->
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

kubectl label ns default environment=test

kubectl create deploy nginx --image=nginx --replicas=6

# error: failed to create deployment: deployments.apps "nginx" is forbidden: ValidatingAdmissionPolicy 'demo-policy.example.com' with binding 'demo-binding-test.example.com' denied request: failed expression: object.spec.replicas <= 5

# Admission policy denied replication as we mentioned in validation policy !

# --------------------------------------------------------------------------

# This setup configures Kubernetes to use an ImagePolicyWebhook admission controller to validate container images before they are deployed !!

README.md  admission.json  api-client-cert.pem  api-client-key.pem  config  webhook.pem  # Required files !

vi /etc/kubernetes/manifests/kube-apiserver.yaml

# Add the below stack in the file 

----->

    - --admission-control-config-file=/etc/kubernetes/demo/admission.json
    - --enable-admission-plugins=NodeRestriction,ImagePolicyWebhook

    volumeMounts:
    - mountPath: /etc/kubernetes/demo
        name: admission
        readOnly: true
    volumes:
    - hostPath:
        path: /etc/kubernetes/demo
    name: admission


kubectl get pods

kubectl run nginx --image=nginx

crictl ps -a

kubectl run nginx --image=nginx

kubectl get pods

# User runs kubectl run nginx --image=nginx.

# kube-apiserver intercepts the request and calls the webhook.

# Webhook server checks the image.

# Response:
# {"allowed": true} → Pod created.
# {"allowed": false,} → Pod blocked.

 