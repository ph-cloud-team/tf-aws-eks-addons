output "addon_names" {
  description = "Installed add-on names."
  value       = module.tf_aws_eks_addons.addon_names
}
