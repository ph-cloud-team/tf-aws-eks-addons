# Usage

## Default Add-Ons

```hcl
module "eks_addons" {
  source = "../../"

  cluster_name       = module.eks.cluster_name
  kubernetes_version = "1.34"

  tags = local.common_tags
}
```

## Override Add-On Configuration

```hcl
module "eks_addons" {
  source = "../../"

  cluster_name       = module.eks.cluster_name
  kubernetes_version = "1.34"

  addons = {
    vpc-cni = {
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
        }
      })
    }
  }

  tags = local.common_tags
}
```

## Add Pod Identity

```hcl
module "eks_addons" {
  source = "../../"

  cluster_name       = module.eks.cluster_name
  kubernetes_version = "1.34"

  addons = {
    aws-ebs-csi-driver = {
      pod_identity_associations = {
        controller = {
          namespace       = "kube-system"
          service_account = "ebs-csi-controller-sa"
          role_arn        = module.ebs_csi_role.role_arn
        }
      }
    }
  }

  tags = local.common_tags
}
```
