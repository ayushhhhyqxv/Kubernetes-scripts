# MANAGER NODE 

vi pod.yaml

kubectl apply -f pod.yaml

kubectl run nginx --image=nginx

# kubectl get pods 
# NAME               READY   STATUS    RESTARTS   AGE
# nginx              1/1     Running   0          64s
# shared-namespace   2/2     Running   0          3m42s

# NOW ON NODE SIDE

ssh node01

ip netns list      # lists all namespaces 

# cni-37e678c7-eeb6-5fbe-b711-69b375f409cb (id: 0)
# cni-75d6ee5a-347e-6cdc-75f7-c58d4b732f6c (id: 1)
# cni-0a1e65c2-45c4-4384-96fd-d6ebf7731f19 (id: 2)

lsns | grep nginx  # lists namespaces of nginx ie mnt,pid,cgroup here 2 pods of nginx are working !

# 4026532573 mnt         2  4761 root             nginx: master process nginx -g daemon off;
# 4026532574 pid         2  4761 root             nginx: master process nginx -g daemon off;
# 4026532575 cgroup      2  4761 root             nginx: master process nginx -g daemon off;
# 4026532639 mnt         2  5505 root             nginx: master process nginx -g daemon off;
# 4026532640 pid         2  5505 root             nginx: master process nginx -g daemon off;
# 4026532641 cgroup      2  5505 root             nginx: master process nginx -g daemon off;

lsns -p 4761  # using process ID to see pod's namespace , you should see uts,net,ipc all 3 are controlled by pause container !

# NS TYPE   NPROCS   PID USER  COMMAND
# 4026531834 time      150     1 root  /sbin/init
# 4026531837 user      150     1 root  /sbin/init
# 4026532507 net         4  4640 65535 /pause
# 4026532567 uts         4  4640 65535 /pause
# 4026532568 ipc         4  4640 65535 /pause
# 4026532573 mnt         2  4761 root  nginx: master process nginx -g daemon off;
# 4026532574 pid         2  4761 root  nginx: master process nginx -g daemon off;
# 4026532575 cgroup      2  4761 root  nginx: master process nginx -g daemon off;

ls -lt /var/run/netns # for CNI managed namespaces !

# -r--r--r-- 1 root root 0 Jul 21 12:11 cni-71d0a680-ac5f-fbac-4cb1-2eb701b4c67a
# -r--r--r-- 1 root root 0 Jul 21 12:09 cni-0a1e65c2-45c4-4384-96fd-d6ebf7731f19
# -r--r--r-- 1 root root 0 Jul 21 12:01 cni-75d6ee5a-347e-6cdc-75f7-c58d4b732f6c
# -r--r--r-- 1 root root 0 Jul 21 12:01 cni-37e678c7-eeb6-5fbe-b711-69b375f409cb

ip netns exec cni-71d0a680-ac5f-fbac-4cb1-2eb701b4c67a  ip link

# eth0@if9 not this type of veth id !

ip link | grep -A1 ^9
 # link-netns cni-0a1e65c2-45c4-4384-96fd-d6ebf7731f19 
 # Shows it is linked with network namespace
 # Basically we first searched for pod's interface which is connected to host/node via veth
 # then found the host end of veth pair shows with which namespace's pod it is connected with CNI id.



