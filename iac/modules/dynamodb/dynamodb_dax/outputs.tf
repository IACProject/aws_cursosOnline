output "dax_cluster_arn" {
  value = aws_dax_cluster.dax_cluster.arn
}

output "dax_endpoint" {
  description = "DAX cluster endpoint"
  value       = aws_dax_cluster.dax_cluster.cluster_address
}