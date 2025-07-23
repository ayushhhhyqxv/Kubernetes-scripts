kubectl config view

export CLUSTER_NAME=kubernetes

export APISERVER=$(kubectl config view -o jsonpath='{.clusters[0].cluster.server}') # gets Kubectl api server url 

curl --cacert /etc/kubernetes/pki/ca.crt $APISERVER/version # Will show details regarding version of k8s

curl --cacert /etc/kubernetes/pki/ca.crt $APISERVER/v1/deployments # Will show list of deployments ! but would fail because of no authentication 

kubectl config --raw  

# Convert client-certificate-data,client-key-data into base64 encoding 

echo "<client-certificate-data_from kubeconfig>" | base64 -d > client

echo "<client-key-data_from kubeconfig>" | base64 -d > key 

controlplane:~$ curl --cacert /etc/kubernetes/pki/ca.crt --cert client --key key $APISERVER/apis/apps/v1/deployments 

# Now you should be able to see all deployments !
# Client certificates proves identity to the API server,authentication as well as authorization 