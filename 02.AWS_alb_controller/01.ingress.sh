# Download IAM Policy
## Download latest
curl -o iam_policy_latest.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
## Verify latest
ls -lrta 

## Download specific version
curl -o iam_policy_v2.3.1.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.3.1/docs/install/iam_policy.json

# Create IAM Policy using policy downloaded 
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy_latest.json

# Make a note of Policy ARN as we are going to use that in next step when creating IAM Role.
    "Arn": "arn:aws:iam::563078753002:policy/AWSLoadBalancerControllerIAMPolicy"


#============== CREATE IAM ROLE FOR ALB LOADBALANCER =======================
# Create an IAM role for the AWS LoadBalancer Controller and attach the role to the Kubernetes service account
#     Applicable only with eksctl managed clusters
#     This command will create an AWS IAM role
#     This command also will create Kubernetes Service Account in k8s cluster
#     In addition, this command will bound IAM Role created and the Kubernetes service account created


# Verify if any existing service account
kubectl get sa -n kube-system
kubectl get sa aws-load-balancer-controller -n kube-system
Obseravation:
1. Nothing with name "aws-load-balancer-controller" should exist

# Template
eksctl create iamserviceaccount \
  --cluster=my_cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \ #Note:  K8S Service Account Name that need to be bound to newly created IAM Role
  --attach-policy-arn=arn:aws:iam::111122223333:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve


# Replaced name, cluster and policy arn (Policy arn we took note in step-02)
eksctl create iamserviceaccount \
  --cluster=eksdemo1 \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::563078753002:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve



# ============Verify ================
# Get IAM Service Account
eksctl  get iamserviceaccount --cluster eksdemo1

# Verify if any existing service account
kubectl get sa -n kube-system
kubectl get sa aws-load-balancer-controller -n kube-system
Obseravation:
1. We should see a new Service account created. 

# Describe Service Account aws-load-balancer-controller
kubectl describe sa aws-load-balancer-controller -n kube-system

