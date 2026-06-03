resource "aws_eks_addon" "this" {
  for_each = local.enabled_addons

  cluster_name                = var.cluster_name
  addon_name                  = each.key
  addon_version               = try(each.value.addon_version, null) != null ? each.value.addon_version : try(data.aws_eks_addon_version.this[each.key].version, null)
  configuration_values        = try(each.value.configuration_values, null)
  preserve                    = try(each.value.preserve, true)
  resolve_conflicts_on_create = try(each.value.resolve_conflicts_on_create, "OVERWRITE")
  resolve_conflicts_on_update = try(each.value.resolve_conflicts_on_update, "PRESERVE")
  service_account_role_arn    = try(each.value.service_account_role_arn, null)

  tags = merge(
    local.common_tags,
    try(each.value.tags, {}),
    {
      Name         = "${var.cluster_name}-${each.key}"
      ResourceRole = "eks-managed-addon"
    }
  )
}

resource "aws_eks_pod_identity_association" "this" {
  for_each = local.pod_identity_associations

  cluster_name    = var.cluster_name
  namespace       = each.value.namespace
  service_account = each.value.service_account
  role_arn        = each.value.role_arn

  tags = merge(
    local.common_tags,
    {
      Name         = "${var.cluster_name}-${each.value.addon_name}-${each.value.namespace}-${each.value.service_account}"
      ResourceRole = "eks-pod-identity-association"
    }
  )

  depends_on = [aws_eks_addon.this]
}
