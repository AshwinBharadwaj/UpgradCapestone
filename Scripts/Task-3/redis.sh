#Install redis cli
sudo apt install redis-tools -y

#Apply redis ConfigMap
kubectl apply -f redis-config.yaml

#Apply redis Deployment
kubectl apply -f redis-deployment.yaml

#Apply redis-cli Deployment
kubectl apply -f redis-deployment-cli.yaml

#Get redis
kubectl get pod -n demo | grep redis

#Connect to redis server
redis-cli -h localhost -p 6379