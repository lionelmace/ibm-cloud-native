# Deploy an IBM Cloud Native Architecture via Terraform

![IBM Cloud Native Architecture](https://raw.githubusercontent.com/lionelmace/ibmcloud-native-architecture/main/ibmcloud-native-architecture.png)

## Cloud Services

The Terraform scripts will provision all those Cloud Services:

* VPC with 3 subnets, 3 public gateways
* Kubernetes cluster
* OpenShift cluster
* Mongo Standard Database with VPE (Virtual Private Endpoint)
* Log Analysis based on Mezmo
* Cloud Monitoring based on Sysdig
* COS (Cloud Object Storage) with a bucket
* Key Protect to encrypt the COS bucket and the Mongo database
* CBR (Context-Based Restrictions) Zones and Rules
* Secrets Manager (Hashicorp Vault aaS) to store the cluster certificate

Both Log Analysis and Monitoring instances will be attached to the clusters.

The Terraform Scripts will no provision those Cloud Services:
Direct Link, VPN Gateway, Transit Gateway, Activity Tracker, Secrets Manager and App ID.

## Resources

* IBM Cloud Terraform Provider is available at [HashiCorp Terraform Registry](https://registry.terraform.io/providers/IBM-Cloud/ibm).
* To use those Terraform, follow this [tutorial](https://lionelmace.github.io/iks-lab/#/05-advanced/appendix-terraform)
