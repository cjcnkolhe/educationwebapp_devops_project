

# --------------------------------
# EC2 Public IP Output
# --------------------------------

output "public_ip" {
  description = "EC2 Jenkins server public IP"
  value       = aws_instance.devops_server.public_ip
}

# output "eks_cluster_name" {
#   description = "EKS cluster name"
#   value       = module.eks.cluster_name
# }

# output "eks_cluster_endpoint" {
#   description = "EKS cluster endpoint"
#   value       = module.eks.cluster_endpoint
# }

# output "vpc_id" {
#   description = "VPC ID"
#   value       = module.vpc.vpc_id
# }
