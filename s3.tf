resource "aws_s3_bucket" "MOTRS3Bucket" {
  bucket        = "${var.bucket_prefix}${var.environment}"
  force_destroy = "true"

  versioning {
    enabled = "${var.bucket_versioning_enabled}"
  }

  policy = "${data.aws_iam_policy_document.s3_policy.json}"

  tags {
    Name        = "${var.project}-${var.environment}-MOTRS3Bucket"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}
