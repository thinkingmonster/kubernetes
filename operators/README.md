# Kubernetes Operator in Python

This project demonstrates how to create a Kubernetes operator in Python using the `kopf` library. The operator listens for the creation of custom resources of kind `MyResource` and performs specific actions (creating a Kubernetes `Deployment`).

## Prerequisites

- Python 3.6+
- Kubernetes cluster
- kubectl configured to access your cluster
- Docker (for building and pushing the operator image)

## Setup

### 1. Create a Virtual Environment

Set up a virtual environment for your project:

```sh
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
```

### 2. Install Required Libraries
Install kopf and the Kubernetes client library:
```sh
pip install kopf kubernetes
```
### 3. Create the Operator Code
Create a new Python file named my_operator.py and add the following code:

```python
import kopf
import kubernetes.client
from kubernetes.client.rest import ApiException

@kopf.on.create('example.com', 'v1', 'myresources')
def create_fn(spec, name, namespace, logger, **kwargs):
    logger.info(f"Handling create event for MyResource: {name} in namespace: {namespace}")
    
    api = kubernetes.client.AppsV1Api()
    deployment = kubernetes.client.V1Deployment(
        api_version="apps/v1",
        kind="Deployment",
        metadata=kubernetes.client.V1ObjectMeta(name=name),
        spec=kubernetes.client.V1DeploymentSpec(
            replicas=1,
            selector=kubernetes.client.V1LabelSelector(
                match_labels={"app": name}
            ),
            template=kubernetes.client.V1PodTemplateSpec(
                metadata=kubernetes.client.V1ObjectMeta(labels={"app": name}),
                spec=kubernetes.client.V1PodSpec(
                    containers=[kubernetes.client.V1Container(
                        name=name,
                        image=spec.get('image', 'nginx')
                    )]
                )
            )
        )
    )
    try:
        api.create_namespaced_deployment(namespace=namespace, body=deployment)
        logger.info(f"Deployment {name} created")
    except ApiException as e:
        logger.error(f"Exception when creating deployment: {e}")
```

### 4. Define the Custom Resource Definition (CRD)

Create a file named myresource-crd.yaml with the following content:

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: myresources.example.com
spec:
  group: example.com
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                image:
                  type: string
  scope: Namespaced
  names:
    plural: myresources
    singular: myresource
    kind: MyResource
    shortNames:
    - mr
```

Apply the CRD to your Kubernetes cluster:

```sh
kubectl apply -f myresource-crd.yaml
```
### 5. Run the Operator Locally

Run the operator locally to test it:

```sh
kopf run my_operator.py
```

### 6. Create a Custom Resource

Create a custom resource YAML file named myresource.yaml:


``` yaml
apiVersion: example.com/v1
kind: MyResource
metadata:
  name: my-app
spec:
  image: nginx:latest

```

Apply the custom resource to your cluster:
```sh
kubectl apply -f myresource.yaml
```

### 7. Verify the Deployment
Check if the deployment has been created:

```sh
kubectl get deployments
```
Inspect the deployment details:

```sh
kubectl describe deployment my-app
```


### 8. Deploy the Operator in Kubernetes
Create a Dockerfile for the operator:

```dockerfile
FROM python:3.8-slim
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir kopf kubernetes
CMD ["kopf", "run", "/app/my_operator.py"]

```
Build and push the Docker image:

```sh

docker build -t thinkingmonster/my-operator:latest .
docker push thinkingmonster/my-operator:latest

docker build -t your-dockerhub-username/my-operator:latest .
docker push your-dockerhub-username/my-operator:latest
```
###  9. Create ServiceAccount, Role, and RoleBinding
Create a file named operator-serviceaccount.yaml with the following content:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-operator
  namespace: default

```
#### Role
Create a file named operator-role.yaml with the following content:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: my-operator
rules:
- apiGroups: [""]
  resources: ["pods", "services", "endpoints", "persistentvolumeclaims"]
  verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets"]
  verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
- apiGroups: ["example.com"]
  resources: ["myresources"]
  verbs: ["get", "list", "watch", "create", "delete", "patch", "update"]
```
#### RoleBinding

Create a file named operator-rolebinding.yaml with the following content:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: my-operator
  namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: my-operator
subjects:
- kind: ServiceAccount
  name: my-operator
  namespace: default
```


### 10. Kubernetes Deployment
Create a deployment YAML file named operator-deployment.yaml:

```yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-operator
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-operator
  template:
    metadata:
      labels:
        app: my-operator
    spec:
      serviceAccountName: my-operator
      containers:
        - name: my-operator
          image: thinkingmonster/my-operator:latest
          imagePullPolicy: Always
```

Deploy the operator to Kubernetes:

```sh
kubectl apply -f operator-deployment.yaml

```

