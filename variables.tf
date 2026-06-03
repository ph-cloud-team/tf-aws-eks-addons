variable "cluster_name" {
  description = "Name of the EKS cluster where add-ons are installed."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version used for most_recent add-on version resolution."
  type        = string
  default     = "1.34"

  validation {
    condition     = contains(["1.33", "1.34", "1.35"], var.kubernetes_version)
    error_message = "kubernetes_version must be one of 1.33, 1.34, or 1.35."
  }
}

variable "enable_default_addons" {
  description = "Install baseline managed add-ons: vpc-cni, coredns, kube-proxy, and aws-ebs-csi-driver."
  type        = bool
  default     = true
}

variable "resolve_most_recent_addon_versions" {
  description = "Resolve most recent EKS add-on versions through the AWS API. Disable in offline module-plan examples."
  type        = bool
  default     = true
}

variable "addons" {
  description = "Map of EKS managed add-ons to install or override."
  type = map(object({
    addon_version               = optional(string)
    most_recent                 = optional(bool, true)
    configuration_values        = optional(string)
    preserve                    = optional(bool, true)
    resolve_conflicts_on_create = optional(string, "OVERWRITE")
    resolve_conflicts_on_update = optional(string, "PRESERVE")
    service_account_role_arn    = optional(string)
    tags                        = optional(map(string), {})
    pod_identity_associations = optional(map(object({
      service_account = string
      namespace       = string
      role_arn        = string
    })), {})
  }))
  default = {}

  validation {
    condition = alltrue(flatten([
      for addon in values(var.addons) : [
        contains(["NONE", "OVERWRITE"], try(addon.resolve_conflicts_on_create, "OVERWRITE")),
        contains(["NONE", "OVERWRITE", "PRESERVE"], try(addon.resolve_conflicts_on_update, "PRESERVE"))
      ]
    ]))
    error_message = "Add-on conflict settings must use supported EKS values."
  }
}

variable "tags" {
  description = "Required enterprise tags applied to supported AWS resources."
  type        = map(string)

  validation {
    condition = alltrue([
      for key in ["Application", "CostCenter", "DataClassification", "Environment", "ManagedBy", "Owner"] : contains(keys(var.tags), key)
    ])
    error_message = "tags must include Application, CostCenter, DataClassification, Environment, ManagedBy, and Owner."
  }
}
