# Security

## Baseline Controls

- Add-on versions are resolved against approved Kubernetes versions.
- AWS permissions are supplied through purpose-built IAM roles.
- Add-on resources are tagged for ownership and auditability.
- Default add-ons use conservative conflict handling to avoid accidental disruption.

## IAM Guidance

Use pod identity for new EKS add-on integrations where possible. Use IRSA when the add-on or cluster version requires it. Do not attach broad administrative policies to add-on service accounts.

## Network Guidance

Private workloads need network access to AWS APIs used by the add-ons. Use VPC endpoints before NAT where AWS supports the endpoint.
