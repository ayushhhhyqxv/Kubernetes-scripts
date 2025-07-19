# Just create an private image in docker hub,build and push it with latest tag on docker hub 

docker build -t  <image-name> . # your docker file must be there to build remember

kubectl create secret docker-registry pullsec --docker-username <username> --docker-password $passwd --docker-email <email>  # pass passwd as a variable 

vi privateimagepull.yaml
->
apiVersion: v1
kind: Pod
metadata:
  name: bootcamp-demo-pod
spec:
  containers:
  - name: bootcamp-demo
    image: <your-pvt-image>
  imagePullSecrets:
  - name: pullsec

# now with help of docker registry secrets pod can fetch docker image easily with my credentials!

kubectl apply -f privateimagepull.yaml
