kubectl run nginx --image=nginx

kubectl get pods 
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          9s

kubectl expose pod nginx --type=NodePort --port 80

kubectl get svc

# NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
# kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        2d
# nginx        NodePort    10.102.90.138   <none>        80:32554/TCP   7s

sudo iptables -t nat -L -n -v | grep -e NodePort        # Lists all the IP tables of node port !
sudo iptables -t nat -L -n -v | grep -e NodePort 
sudo iptables -t nat -L -n -v | grep -e NodePort -e KUBE # Segregates within node-port with KUBE name

#    47  2820 KUBE-SERVICES  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes service portals */
#  1067 64268 KUBE-SERVICES  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes service portals */
#  1064 64049 KUBE-POSTROUTING  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes postrouting rules */
# Chain KUBE-EXT-2CMXP7HKUVJN7L6M (2 references)
#     0     0 KUBE-MARK-MASQ  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* masquerade traffic for default/nginx external destinations */
#     0     0 KUBE-SVC-2CMXP7HKUVJN7L6M  0    --  *      *       0.0.0.0/0            0.0.0.0/0           
# Chain KUBE-KUBELET-CANARY (0 references)
# Chain KUBE-MARK-MASQ (14 references)
# Chain KUBE-NODEPORTS (1 references)
#     0     0 KUBE-EXT-2CMXP7HKUVJN7L6M  6    --  *      *       0.0.0.0/0            127.0.0.0/8          /* default/nginx */ tcp dpt:32554 nfacct-name  localhost_nps_accepted_pkts
#     0     0 KUBE-EXT-2CMXP7HKUVJN7L6M  6    --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/nginx */ tcp dpt:32554
# Chain KUBE-POSTROUTING (1 references)
# Chain KUBE-PROXY-CANARY (0 references)
# Chain KUBE-SEP-ABG426TTTCGMOND7 (1 references)
#     0     0 KUBE-MARK-MASQ  0    --  *      *       192.168.1.2          0.0.0.0/0            /* kube-system/kube-dns:dns-tcp */
# Chain KUBE-SEP-D23ODROEH5R4FSGE (1 references)
#    17  1020 KUBE-MARK-MASQ  0    --  *      *       172.30.1.2           0.0.0.0/0            /* default/kubernetes:https */
# Chain KUBE-SEP-FQFPWV2P4G3WD2SN (1 references)
#     0     0 KUBE-MARK-MASQ  0    --  *      *       192.168.1.3          0.0.0.0/0            /* kube-system/kube-dns:dns-tcp */
# Chain KUBE-SEP-GHNVWKROTCCBFQKZ (1 references)
#     0     0 KUBE-MARK-MASQ  0    --  *      *       192.168.1.2          0.0.0.0/0            /* kube-system/kube-dns:dns */
# Chain KUBE-SEP-I63X27HX2ZZBGI74 (1 references)
#     0     0 KUBE-MARK-MASQ  0    --  *      *       192.168.1.3          0.0.0.0/0            /* kube-system/kube-dns:metrics */
# Chain KUBE-SEP-LJUUEGC24UMYBEWU (1 references)
#     0     0 KUBE-MARK-MASQ  0    --  *      *       192.168.1.4          0.0.0.0/0            /* default/nginx */
# Chain KUBE-SEP-QTGKLRHEXOFUNUWC (1 references)
#     0     0 KUBE-MARK-MASQ  0    --  *      *       192.168.1.3          0.0.0.0/0            /* kube-system/kube-dns:dns */
# Chain KUBE-SEP-UG4OSZR4VSWZ27C5 (1 references)
#     0     0 KUBE-MARK-MASQ  0    --  *      *       192.168.1.2          0.0.0.0/0            /* kube-system/kube-dns:metrics */
# Chain KUBE-SERVICES (2 references)
#     0     0 KUBE-SVC-2CMXP7HKUVJN7L6M  6    --  *      *       0.0.0.0/0            10.102.90.138        /* default/nginx cluster IP */ tcp dpt:80
#     0     0 KUBE-SVC-NPX46M4PTMTKRN6Y  6    --  *      *       0.0.0.0/0            10.96.0.1            /* default/kubernetes:https cluster IP */ tcp dpt:443
#     0     0 KUBE-SVC-TCOU7JCQXEZGVUNU  17   --  *      *       0.0.0.0/0            10.96.0.10           /* kube-system/kube-dns:dns cluster IP */ udp dpt:53
#     0     0 KUBE-SVC-ERIFXISQEP7F7OF4  6    --  *      *       0.0.0.0/0            10.96.0.10           /* kube-system/kube-dns:dns-tcp cluster IP */ tcp dpt:53
#     0     0 KUBE-SVC-JD5MR3NA4I4DYORP  6    --  *      *       0.0.0.0/0            10.96.0.10           /* kube-system/kube-dns:metrics cluster IP */ tcp dpt:9153
#   299 17940 KUBE-NODEPORTS  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* kubernetes service nodeports; NOTE: this must be the last rule in this chain */ ADDRTYPE match dst-type LOCAL
# Chain KUBE-SVC-2CMXP7HKUVJN7L6M (2 references)
#     0     0 KUBE-MARK-MASQ  6    --  *      *      !192.168.0.0/16       10.102.90.138        /* default/nginx cluster IP */ tcp dpt:80
#     0     0 KUBE-SEP-LJUUEGC24UMYBEWU  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/nginx -> 192.168.1.4:80 */
# Chain KUBE-SVC-ERIFXISQEP7F7OF4 (1 references)
#     0     0 KUBE-MARK-MASQ  6    --  *      *      !192.168.0.0/16       10.96.0.10           /* kube-system/kube-dns:dns-tcp cluster IP */ tcp dpt:53
#     0     0 KUBE-SEP-ABG426TTTCGMOND7  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* kube-system/kube-dns:dns-tcp -> 192.168.1.2:53 */ statistic mode random probability 0.50000000000
#     0     0 KUBE-SEP-FQFPWV2P4G3WD2SN  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* kube-system/kube-dns:dns-tcp -> 192.168.1.3:53 */
# Chain KUBE-SVC-JD5MR3NA4I4DYORP (1 references)
#     0     0 KUBE-MARK-MASQ  6    --  *      *      !192.168.0.0/16       10.96.0.10           /* kube-system/kube-dns:metrics cluster IP */ tcp dpt:9153
#     0     0 KUBE-SEP-UG4OSZR4VSWZ27C5  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* kube-system/kube-dns:metrics -> 192.168.1.2:9153 */ statistic mode random probability 0.50000000000
#     0     0 KUBE-SEP-I63X27HX2ZZBGI74  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* kube-system/kube-dns:metrics -> 192.168.1.3:9153 */
# Chain KUBE-SVC-NPX46M4PTMTKRN6Y (1 references)
#    17  1020 KUBE-MARK-MASQ  6    --  *      *      !192.168.0.0/16       10.96.0.1            /* default/kubernetes:https cluster IP */ tcp dpt:443
#    19  1140 KUBE-SEP-D23ODROEH5R4FSGE  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/kubernetes:https -> 172.30.1.2:6443 */
# Chain KUBE-SVC-TCOU7JCQXEZGVUNU (1 references)
#     0     0 KUBE-MARK-MASQ  17   --  *      *      !192.168.0.0/16       10.96.0.10           /* kube-system/kube-dns:dns cluster IP */ udp dpt:53
#     0     0 KUBE-SEP-GHNVWKROTCCBFQKZ  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* kube-system/kube-dns:dns -> 192.168.1.2:53 */ statistic mode random probability 0.50000000000
#     0     0 KUBE-SEP-QTGKLRHEXOFUNUWC  0    --  *      *       0.0.0.0/0            0.0.0.0/0            /* kube-system/kube-dns:dns -> 192.168.1.3:53 */

sudo iptables -t nat -L -n -v | grep 32554    # watching packets send on our node port which is specified

    # 0     0 KUBE-EXT-2CMXP7HKUVJN7L6M  6    --  *      *       0.0.0.0/0            127.0.0.0/8          /* default/nginx */ tcp dpt:32554 nfacct-name  localhost_nps_accepted_pkts
    # 0     0 KUBE-EXT-2CMXP7HKUVJN7L6M  6    --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/nginx */ tcp dpt:32554

kubectl get pods -owide 

NAME    READY   STATUS    RESTARTS   AGE     IP            NODE     NOMINATED NODE   READINESS GATES
nginx   1/1     Running   0          4m48s   192.168.1.4   node01   <none>           <none>

curl 192.168.1.4  # Hitting our node01 server to check packets are exactly send and received on that , you can even check using external server using IP address 192.168.1.4:32554 !
--->
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

sudo iptables -t nat -L -n -v | grep 32554  # Now you can see accepted packets as well on our port
    0     0 KUBE-EXT-2CMXP7HKUVJN7L6M  6    --  *      *       0.0.0.0/0            127.0.0.0/8          /* default/nginx */ tcp dpt:32554 nfacct-name  localhost_nps_accepted_pkts
    2   120 KUBE-EXT-2CMXP7HKUVJN7L6M  6    --  *      *       0.0.0.0/0            0.0.0.0/0            /* default/nginx */ tcp dpt:32554
