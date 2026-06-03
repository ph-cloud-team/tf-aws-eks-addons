# tf-aws-eks-addons

Enterprise Terraform module for AWS EKS managed add-ons.

This module installs and manages platform-approved EKS add-ons after the cluster and node groups are available. It defaults to the baseline components required for a private EKS platform: `vpc-cni`, `coredns`, `kube-proxy`, and `aws-ebs-csi-driver`.

## What This Module Creates

- `aws_eks_addon` resources from a governed add-on map.
- Optional add-on version discovery through `aws_eks_addon_version`.
- Optional EKS pod identity associations for add-ons that need AWS API permissions.
- Enterprise tags on supported resources.

## Governance Baseline

- Kubernetes version is constrained to approved versions.
- Default add-ons preserve running resources during destroy unless explicitly overridden.
- Conflict resolution defaults are controlled and explicit.
- IAM permissions for add-ons are supplied by dedicated IRSA or pod identity role modules.
- The module does not create cluster, node group, or IAM role resources.

## Dependency Order

Use this module after:

1. `tf-aws-eks-cluster`
2. `tf-aws-eks-node-group`
3. `tf-aws-eks-irsa` or pod identity IAM role modules when add-ons need AWS permissions

## Example

```hcl
module "eks_addons" {
  source = "git::http://gitlab.midhtech.local/cloud_team/tf-modules/aws/containers/tf-aws-eks-addons.git?ref=v1.0.0"

  cluster_name       = module.eks.cluster_name
  kubernetes_version = "1.34"

  addons = {
    aws-ebs-csi-driver = {
      most_recent = true
      pod_identity_associations = {
        controller = {
          namespace       = "kube-system"
          service_account = "ebs-csi-controller-sa"
          role_arn        = module.ebs_csi_pod_identity.role_arn
        }
      }
    }
  }

  tags = local.common_tags
}
```

## Validation

```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
```

Shared GitLab CI should also run Checkov and custom OPA/Rego policies from `platform-policies`.
