brew install weaveworks/tap/eksctl
export cluster_name=attractive-gopher
eksctl create cluster --name=$cluster_name
eksctl utils associate-iam-oidc-provider --cluster=$cluster_name --approve
kubectl apply -f rbac-role.yaml
aws iam create-policy --policy-name ALBIngressControllerIAMPolicy --policy-document file://iam-policy.json
eksctl create iamserviceaccount \
       --cluster=$cluster_name \
       --namespace=kube-system \
       --role-name=alb-ingress-controller-role \
       --name=alb-ingress-controller \
       --attach-policy-arn="arn:aws:iam::563078753002:policy/ALBIngressControllerIAMPolicy" \
       --override-existing-serviceaccounts \
       --approve

helm repo add eks https://aws.github.io/eks-charts
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=$cluster_name --set serviceAccount.create=false --set serviceAccount.name=alb-ingress-controller

# https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html