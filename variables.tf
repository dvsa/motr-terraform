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

variable "bucket_versioning_enabled" {
  type        = "string"
  description = "S3 bucket versioning switch"
}

variable "with_cloudfront" {
  type        = "string"
  description = "CloudFront on/off switch"
}

variable "waf_acl_id" {
  type        = "string"
  description = "WAF Web ACL id"
}

variable "cf_apig_channel_key" {
  type        = "string"
  description = "API Gateway key value"
}

variable "public_dns_domain" {
  type        = "string"
  description = "Public DNS domain name"
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

variable "MotrWebHandler_mem_size" {
  type        = "string"
  description = "Amount of memory in MB Lambda Function can use at runtime"
}

variable "MotrWebHandler_timeout" {
  type        = "string"
  description = "The amount of time Lambda Function has to run in seconds"
}

variable "webapp_log_level" {
  type        = "string"
  description = "WebApp Lambda log level"
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

variable "MotrSubscriptionLoader_s3_key" {
  type        = "string"
  description = "MotrSubscriptionLoader Lambda Handler S3 key"
}

variable "MotrSubscriptionLoader_ver" {
  type        = "string"
  description = "MotrSubscriptionLoader Lambda version"
}

variable "MotrSubscriptionLoader_publish" {
  type        = "string"
  description = "MotrSubscriptionLoader Lambda publish switch"
}

variable "MotrSubscriptionLoader_mem_size" {
  type        = "string"
  description = "Amount of memory in MB Lambda Function can use at runtime"
}

variable "MotrSubscriptionLoader_timeout" {
  type        = "string"
  description = "The amount of time Lambda Function has to run in seconds"
}

variable "subscr_loader_log_level" {
  type        = "string"
  description = "MotrSubscriptionNotifier Lambda log level"
}

variable "MotrNotifier_s3_key" {
  type        = "string"
  description = "MotrNotifier Lambda Handler S3 key"
}

variable "MotrNotifier_ver" {
  type        = "string"
  description = "MotrNotifier Lambda version"
}

variable "MotrNotifier_publish" {
  type        = "string"
  description = "MotrNotifier Lambda publish switch"
}

variable "MotrNotifier_mem_size" {
  type        = "string"
  description = "Amount of memory in MB Lambda Function can use at runtime"
}

variable "MotrNotifier_timeout" {
  type        = "string"
  description = "The amount of time Lambda Function has to run in seconds"
}

variable "notifier_log_level" {
  type        = "string"
  description = "MotrNotifier Lambda log level"
}

variable "motr_loader_enabled" {
  type        = "string"
  description = "Whether the rule should be enabled"       
}

variable "motr_loader_schedule" {
  type        = "string"
  description = "The scheduling expression. For example, cron(0 3 * * ? *)" 
}

variable "motr_notifier_enabled" {
  type        = "string"
  description = "Whether the rule should be enabled" 
}

variable "motr_notifier_schedule" {
  type        = "string"
  description = "The scheduling expression. For example, rate(5 minutes)" 
}

variable "motr_subscribtion_q_delay_s" {
  type        = "string"
  description = "The time in seconds that the delivery of all messages in the queue will be delayed"
}

variable "motr_subscribtion_q_max_msg_size" {
  type        = "string"
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it"
}

variable "motr_subscribtion_q_msg_retention_s" {
  type        = "string"
  description = "The number of seconds Amazon SQS retains a message"
}

variable "motr_subscribtion_q_receive_wait_s" {
  type        = "string"
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning"
}

variable "confirmation_template_id" {
  type        = "string"
  description = "Gov Notify template ID"
}

variable "gov_notify_api_token" {
  type        = "string"
  description = "Gov Notify API key"
}

variable "base_url" {
  type        = "string"
  description = "MOT reminder base url"
}

variable "kms_key_rotation" {
  type        = "string"
  description = "KMS key rotation enable"
  default     = "false"
}

variable "kms_deletion_window" {
  type        = "string"
  description = "KMS key deletion window"
  default     = "30"
}
