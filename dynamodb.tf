resource "aws_dynamodb_table" "motr-cancelled_subscription" {
  name           = "motr-${var.environment}-cancelled_subscription"
  read_capacity  = "${var.tb_canc_subscr_read_capacity}"
  write_capacity = "${var.tb_canc_subscr_write_capacity}"
  hash_key       = "email"
  range_key      = "id"

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
    name               = "email-gsi"
    hash_key           = "email"
    read_capacity      = "${var.ix_canc_subscr_emailg_read_capacity}"
    write_capacity     = "${var.ix_canc_subscr_emailg_write_capacity}"
    projection_type    = "INCLUDE"
    non_key_attributes = ["id", "vrm", "cancelled_at"]
  }

  global_secondary_index {
    name               = "vrm-gsi"
    hash_key           = "vrm"
    read_capacity      = "${var.ix_canc_subscr_vrmg_read_capacity}"
    write_capacity     = "${var.ix_canc_subscr_vrmg_write_capacity}"
    projection_type    = "INCLUDE"
    non_key_attributes = ["email", "id", "cancelled_at"]
  }

  tags {
    Name        = "${var.environment}-${var.project}-motr-cancelled_subscription"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

#### deletion

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
    non_key_attributes = ["mot_due_date", "mot_test_number"]
  }

  tags {
    Name        = "${var.project}-${var.environment}-motr-pending_subscription"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}
