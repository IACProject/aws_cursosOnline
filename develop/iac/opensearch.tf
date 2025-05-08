resource "aws_opensearch_domain" "courses_search" {
  domain_name    = "online-ready-courses-${var.environment}"
  engine_version = "OpenSearch_2.5"

  cluster_config {
    instance_type            = "t3.small.search"
    instance_count           = 2
    zone_awareness_enabled   = true
    zone_awareness_config {
      availability_zone_count = 2
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = "admin"
      master_user_password = "OnlineReady@123" # Usar Secrets Manager en producción
    }
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  tags = {
    Domain = "OnlineReady-Courses"
  }
}

resource "aws_iam_service_linked_role" "opensearch" {
  aws_service_name = "es.amazonaws.com"
}