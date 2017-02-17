resource "aws_s3_bucket" "MOTRS3Bucket" {
  # AWS console bug: API "test" button does not work if S3 bucket and API gateway are in the same region.
  # http://stackoverflow.com/questions/33954150/aws-api-gateway-method-to-serve-static-content-from-s3-bucket
  bucket        = "${var.bucket_prefix}${var.environment}"
  force_destroy = "true"
  versioning {
    enabled = "${var.bucket_versioning_enabled}"
  }
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "AllowPublicRead",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${var.bucket_prefix}${var.environment}/assets/*"
    }
  ]
}
EOF
  tags {
    Name        = "motr-${var.environment}"
    environment = "${var.environment}"
  }
}
