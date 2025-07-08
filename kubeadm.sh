# Tool used for creating K8S production grade cluster allowing more complex configuration than minikube

kubeadm init # fetches and downloads its services

# Do all tasks as root user ! because for RBAC (role based access control) it would later cause issue

# Check 'conf' file and its contents,it has has details about cluster 

kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml # Weave helps computers in a cluster connect and daemon ensures none node is left ! 

kubeadm token create --print-join-command # Instead of printing only the token, print the full 'kubeadm join' flag needed to join the cluster using the token

# NOW ON NODE SIDE COMMANDS :

sudo curl -fsSlo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list 

# for official kubernetes 

sudo apt install -y kubelet kubeadm kubectl # last three commands and docker should be installed on both manager as well as node !

# Continue in node 

kubeadm reset pre-flight checks # stops if already it is manager/worker and resets ! 

# Add the given worker token here then add '--v=5' for kubeadm version and open the specific port which is asked (default:6443)

# Switch to manager server and do the deployment thing same as it is





