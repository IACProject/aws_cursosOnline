variable "db_user" {}
variable "db_password" {}
variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  type        = string
}
variable "security_group_id" {}
variable "environment" {}