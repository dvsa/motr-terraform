data "aws_iam_policy_document" "s3_policy" {
  statement {
    sid     = "Grant CF OAI access to static assets on S3"
    actions = ["s3:GetObject"]

    resources = [
      "arn:aws:s3:::${var.bucket_prefix}${var.environment}/assets/*",
      "arn:aws:s3:::${var.bucket_prefix}${var.environment}/errorpages/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["${var.with_cloudfront ? "${aws_cloudfront_origin_access_identity.oai.iam_arn}" : "*"}"]
    }
  }
}
