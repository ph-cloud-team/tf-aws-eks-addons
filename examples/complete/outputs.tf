output "addon_versions" {
  description = "Installed add-on versions."
  value       = module.tf_aws_eks_addons.addon_versions
}

output "pod_identity_association_ids" {
  description = "Pod identity association IDs."
  value       = module.tf_aws_eks_addons.pod_identity_association_ids
}
