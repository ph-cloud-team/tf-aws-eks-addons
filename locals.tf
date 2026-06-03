locals {
  module_name = "tf-aws-eks-addons"

  default_addons = {
    vpc-cni = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "PRESERVE"
      preserve                    = true
    }
    coredns = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "PRESERVE"
      preserve                    = true
    }
    kube-proxy = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "PRESERVE"
      preserve                    = true
    }
    aws-ebs-csi-driver = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "PRESERVE"
      preserve                    = true
    }
  }

  enabled_addons = var.enable_default_addons ? merge(local.default_addons, var.addons) : var.addons

  addon_versions = {
    for name, addon in local.enabled_addons : name => addon
    if var.resolve_most_recent_addon_versions && try(addon.addon_version, null) == null && try(addon.most_recent, true)
  }

  pod_identity_associations = length(local.enabled_addons) == 0 ? {} : merge([
    for addon_name, addon in local.enabled_addons : {
      for association_name, association in try(addon.pod_identity_associations, {}) :
      "${addon_name}:${association_name}" => merge(association, {
        addon_name = addon_name
      })
    }
  ]...)

  common_tags = merge(
    var.tags,
    {
      Module = local.module_name
    }
  )
}
