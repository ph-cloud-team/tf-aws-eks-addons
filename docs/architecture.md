# Architecture

The add-ons module is the final infrastructure-layer step before workload delivery. It assumes the cluster API is reachable by the runner and that worker capacity is already available for add-ons that schedule pods.

## Managed Add-On Model

The module manages add-ons through a map so environments can override versions, configuration values, and identity associations without changing module code.

## Identity Model

Add-on permissions are not embedded in this module. Use IAM role modules to create IRSA or pod identity roles, then pass those role ARNs into the relevant add-on entry.

## Private Cluster Considerations

For private EKS platforms, install the VPC endpoint set for ECR, S3, CloudWatch Logs, STS, EC2, and KMS before relying on add-ons or workloads that need AWS APIs without direct internet access.
