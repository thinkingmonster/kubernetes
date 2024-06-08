import kopf
import kubernetes.client
from kubernetes.client.rest import ApiException

# Define the handler for the custom resource
@kopf.on.create('example.com', 'v1', 'myresources')
def create_fn(spec, name, namespace, logger, **kwargs):
    logger.info(f"Handling create event for MyResource: {name} in namespace: {namespace}")
    # Perform actions here, e.g., create a deployment
    api = kubernetes.client.AppsV1Api()
    deployment = kubernetes.client.V1Deployment(
        api_version="apps/v1",
        kind="Deployment",
        metadata=kubernetes.client.V1ObjectMeta(name=name),
        spec=kubernetes.client.V1DeploymentSpec(
            replicas=5,
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
