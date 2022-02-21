#Get existing namespaces
kubectl get namespaces

#Deploy the namespace
kubectl create -f ./namespace.yaml

#Deployment
kubectl apply -f upg-loadme.yaml
kubectl get deployments --namespace demo
kubectl get deployment -n kube-system aws-load-balancer-controller