resource "aws_dynamodb_table" "notifier_table" {
    name         = "notifier-table"
    billing_mode = "PROVISIONED"
    read_capacity  = 10
    write_capacity = 10
    hash_key     = "id"

    attribute {
        name = "id"
        type = "S"
    }

    tags = {
        Name        = "cursoonline"
        Environment = "dev"
    }
}