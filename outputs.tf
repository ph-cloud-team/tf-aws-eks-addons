output "module_name" {
  description = "Name of the Terraform module."
  value       = local.module_name
}

output "addon_names" {
  description = "Installed EKS managed add-on names."
  value       = keys(aws_eks_addon.this)
}

output "addon_arns" {
  description = "Installed EKS managed add-on ARNs."
  value       = { for name, addon in aws_eks_addon.this : name => addon.arn }
}

output "addon_versions" {
  description = "Installed EKS managed add-on versions."
  value       = { for name, addon in aws_eks_addon.this : name => addon.addon_version }
}

output "pod_identity_association_ids" {
  description = "EKS pod identity association IDs."
  value       = { for name, association in aws_eks_pod_identity_association.this : name => association.association_id }
}
