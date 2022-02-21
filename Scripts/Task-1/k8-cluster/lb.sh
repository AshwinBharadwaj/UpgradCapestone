#Create IAM Policies
aws iam create-policy \
  --policy-name LoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json

eksctl create iamserviceaccount \
--cluster=ashwin-eks \
--region=us-east-1 \
--namespace=kube-system \
--name=load-balancer-controller \
--attach-policy-arn=arn:aws:iam::417139048224:policy/LoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--approve


#Create IAM additional Policy
aws iam create-policy \
--policy-name LoadBalancerControllerAdditionalIAMPolicy \
--policy-document file://iam_policy_v1_to_v2_additional.json

#Attach IAM Policy to Role
aws iam attach-role-policy \
--role-name eksctl-ashwin-eks-addon-iamserviceaccount-ce-Role1-TBLOPQ4J84Y9 \
--policy-arn arn:aws:iam::417139048224:policy/LoadBalancerControllerAdditionalIAMPolicy

#AWS Load balancer controller
helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm install load-balancer-controller eks/load-balancer-controller \
-n kube-system \
--set clusterName=ashwin-eks \
--set serviceAccount.create=false \
--set serviceAccount.name=load-balancer-controller 

kubectl apply -f aws-load-balancer-controller_crds.yaml

#Kubernetes-metrics server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

#Cluster autoscaler for AWS
curl -o cluster-autoscaler.yaml https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler.yaml
--Manually update the yaml file

kubectl apply -f cluster-autoscaler.yaml

kubectl annotate serviceaccount cluster-autoscaler \
-n kube-system \
eks.amazonaws.com/role-arn=arn:aws:iam::417139048224:role/eksctl-ashwin-eks-cluster-ServiceRole-6SW59G9Y2UEU

kubectl patch deployment cluster-autoscaler \
-n kube-system \
-p '{"spec":{"template":{"metadata":{"annotations":{"cluster-autoscaler.kubernetes.io/safe-to-evict": "false"}}}}}'

kubectl -n kube-system edit deployment.apps/cluster-autoscaler

kubectl set image deployment cluster-autoscaler \
-n kube-system \

cluster-autoscaler=k8s.gcr.io/autoscaling/cluster-autoscaler:v1.23.3

kubectl -n kube-system logs -f deployment.apps/cluster-autoscaler
