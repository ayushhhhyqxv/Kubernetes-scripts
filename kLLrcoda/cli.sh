# In UBUNTU workspace :

docker run -d --name my-nginx-container --memory 512m --cpus 1 nginx # Make sure to have docker bro !

ps aux | grep '[n]ginx' | sort -n -k 2 | head -n 1 | awk '{print $2}'

# - List all processes (ps aux)
# - Filter for Nginx processes (grep '[n]ginx')
# - Sort numerically by PID (sort -n -k 2)
# - Select first result (head -n 1)
# - Extract PID using awk (awk '{print $2}')

lsns -p pid

# check out cgroups,system.slices,memory stats of docker/containerD container we created now 

# In K8S workspace :

kubectl run nginx --image=nginx 

kubectl get pods -owide # take the node1 or whatever node name it is 

ssh <node-name>

crictl ps # just like docker ps for containerD,crictl is a CLI designed to interact with K8S Container Runtime Interface (CRI) compatible runtimes, and containerd is a popular CRI-compliant runtime. 