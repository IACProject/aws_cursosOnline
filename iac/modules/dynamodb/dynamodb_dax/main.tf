resource "aws_dax_cluster" "dax_cluster" {
  cluster_name = "curso-dax-cluster"
  node_type    = "dax.r4.large"
  replication_factor = 3
  iam_role_arn = var.dax_role_arn

  tags = {
    Name        = "CursoDAX"
    Environment = var.environment
  }
}