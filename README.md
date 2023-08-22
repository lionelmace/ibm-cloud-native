# Deploy an IBM Cloud Native Architecture via Terraform

The IBM Cloud Native Architecture is as follow:

![diagram](https://raw.githubusercontent.com/lionelmace/mytodo/master/images/ibmcloud-mytodo-tf.png)

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

## Resources

* IBM Cloud Terraform Provider is available at [HashiCorp Terraform Registry](https://registry.terraform.io/providers/IBM-Cloud/ibm).
* To use those Terraform, follow this [tutorial](https://lionelmace.github.io/iks-lab/#/05-advanced/appendix-terraform)
