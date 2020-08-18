# Helm installation
. /vagrant/centos/00-env.sh
wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz
tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz
mv linux-amd64/helm /bin/helm




#Metric server installation
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml


# Metric server tries to connect on node hostname but we want to connect the same to internal ip. Edit the metric server deployment and make sure that  run command is as shown below.

# spec:
#       containers:
#   - command:
#     - /metrics-server
#     - --cert-dir=/tmp
#     - --secure-port=4443
#     - --kubelet-insecure-tls
#         - --kubelet-preferred-address-types=InternalIP
#         image: k8s.gcr.io/metrics-server-amd64:v0.3.6
#         imagePullPolicy: IfNotPresent
#         name: metrics-server
#         ports:

#Install Ingress
/bin/helm repo add stable https://kubernetes-charts.storage.googleapis.com/
kubectl create namespace nginx-ingress
/bin/helm install my-nginx stable/nginx-ingress --set rbac.create=true --set controller.service.type=NodePort -n nginx-ingress

# In case you want to delete the ingress controller.
#/usr/local/bin/helm delete my-nginx