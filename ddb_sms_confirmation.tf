resource "aws_dynamodb_table" "motr-sms_confirmation" {
  name           = "motr-${var.environment}-sms_confirmation"
  read_capacity  = "${var.tb_sms_confirmation_read_capacity}"
  write_capacity = "${var.tb_sms_confirmation_write_capacity}"
  hash_key       = "id"
  range_key      = "phone_number"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "phone_number"
    type = "S"
  }

  tags {
    Name        = "${var.project}-${var.environment}-motr-sms_confirmation"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }

  ttl {
    attribute_name = "deletion_date"
    enabled        = true
  }
}
