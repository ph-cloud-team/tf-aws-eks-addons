data "aws_eks_addon_version" "this" {
  for_each = local.addon_versions

  addon_name         = each.key
  kubernetes_version = var.kubernetes_version
  most_recent        = true
}
