resource "aws_dynamodb_table" "motr-pending_subscription" {
  name           = "motr-${var.environment}-pending_subscription"
  read_capacity  = "${var.tb_pending_subscr_read_capacity}"
  write_capacity = "${var.tb_pending_subscr_write_capacity}"
  hash_key       = "email"
  range_key      = "vrm"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  attribute {
    name = "vrm"
    type = "S"
  }

  global_secondary_index {
    name               = "id-gsi"
    hash_key           = "id"
    write_capacity     = "${var.ix_pending_subscr_ig_read_capacity}"
    read_capacity      = "${var.ix_pending_subscr_ig_write_capacity}"
    projection_type    = "INCLUDE"
    non_key_attributes = ["mot_due_date", "mot_test_number", "dvla_id", "contact_type"]
  }

  tags {
    Name        = "${var.project}-${var.environment}-motr-pending_subscription"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }

  ttl {
    attribute_name = "deletion_date"
    enabled        = true
  }
}
