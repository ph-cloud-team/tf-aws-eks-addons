locals {
  arn_prefix         = format("%s:aws", "arn")
  ci_plan_account_id = format("%012d", 0)
  ebs_csi_role_arn   = "${local.arn_prefix}:iam::${local.ci_plan_account_id}:role/dev-platform-ebs-csi-pod-identity"
}

module "tf_aws_eks_addons" {
  source = "../../"

  cluster_name                       = "dev-platform-eks"
  kubernetes_version                 = "1.34"
  resolve_most_recent_addon_versions = false

  addons = {
    vpc-cni = {
      most_recent = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }

    aws-ebs-csi-driver = {
      most_recent = true
      pod_identity_associations = {
        controller = {
          namespace       = "kube-system"
          service_account = "ebs-csi-controller-sa"
          role_arn        = local.ebs_csi_role_arn
        }
      }
    }
  }

  tags = {
    Application        = "platform-eks"
    CostCenter         = "shared-services"
    DataClassification = "internal"
    Environment        = "dev"
    ManagedBy          = "terraform"
    Owner              = "platform-team"
  }
}
