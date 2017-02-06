variable "aws_region" {
  type        = "string"
  description = "AWS region"
}

variable "project" {
  type        = "string"
  description = "Project name"
}

variable "environment" {
  type        = "string"
  description = "Environment name"
}

variable "bucket_prefix" {
  type        = "string"
  description = "S3 bucket prefix"
}

variable "with_cloudfront" {
  type        = "string"
  description = "CloudFront on/off switch"
}

variable "public_dns_domain" {
  type        = "string"
  description = "Public DNS domain name"
}

variable "webapp_log_level" {
  type        = "string"
  description = "WebApp Lambda log level"
}

variable "static_assets_hash" {
  type        = "string"
  description = "Static assets current commit hash"
}

variable "binary_media_types" {
  type        = "list"
  description = "APIG binary media types"
}

variable "MotrWebHandler_s3_key" {
  type        = "string"
  description = "WebApp Lambda Handler S3 key"
}

variable "MotrWebHandler_ver" {
  type        = "string"
  description = "WebApp Lambda version"
}

variable "MotrWebHandler_publish" {
  type        = "string"
  description = "WebApp Lambda publish switch"
}

variable "tb_subscr_read_capacity" {
  type        = "string"
  description = "Table motr-subscription read capacity"
}

variable "tb_subscr_write_capacity" {
  type        = "string"
  description = "Table motr-subscription write capacity"
}

variable "tb_pending_subscr_read_capacity" {
  type        = "string"
  description = "Table motr-pending_subscription read capacity"
}

variable "tb_pending_subscr_write_capacity" {
  type        = "string"
  description = "Table motr-pending_subscription write capacity"
}

variable "ix_subscr_ddg_read_capacity" {
  type        = "string"
  description = "Index due-date-md-gsi (motr-subscription) read capacity"
}

variable "ix_subscr_ddg_write_capacity" {
  type        = "string"
  description = "Index due-date-md-gsi (motr-subscription) write capacity"
}

variable "ix_subscr_ig_read_capacity" {
  type        = "string"
  description = "Index id-gsi (motr-subscription) read capacity"
}

variable "ix_subscr_ig_write_capacity" {
  type        = "string"
  description = "Index id-gsi (motr-subscription) write capacity"
}

variable "ix_pending_subscr_ig_read_capacity" {
  type        = "string"
  description = "Index id-gsi (motr-pending_subscription) read capacity"
}

variable "ix_pending_subscr_ig_write_capacity" {
  type        = "string"
  description = "Index id-gsi (motr-pending_subscription) write capacity"
}

variable "mot_test_reminder_info_endpoint" {
  type        = "string"
  description = "MOT test reminder info endpoint"
}

variable "notify_subscription_template_id" {
  type        = "string"
  description = "Gov Notify template ID"
}

variable "notify_client_api_key" {
  type        = "string"
  description = "Gov Notify API key"
}
