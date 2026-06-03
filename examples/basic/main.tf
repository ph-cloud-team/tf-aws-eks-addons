module "tf_aws_eks_addons" {
  source = "../../"

  cluster_name                       = "dev-platform-eks"
  kubernetes_version                 = "1.34"
  resolve_most_recent_addon_versions = false

  tags = {
    Application        = "platform-eks"
    CostCenter         = "shared-services"
    DataClassification = "internal"
    Environment        = "dev"
    ManagedBy          = "terraform"
    Owner              = "platform-team"
  }
}
