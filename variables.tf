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

variable "logging_bucket" {
  type        = "string"
  description = "Separate S3 bucket for storing logs"
}

variable "waf_acl_id" {
  type        = "string"
  description = "WAF Web ACL id"
}

variable "public_dns_domain" {
  type        = "string"
  description = "Public DNS domain name"
}

variable "alias_record_name" {
  type        = "string"
  description = "DNS alias record name that will be appended in front of the public_dns_domain"
}

variable "static_assets_hash" {
  type        = "string"
  description = "Static assets current commit hash"
}

variable "status_email_recipients" {
  type        = "string"
  description = "List of email addresses which the daily failed notification count is sent"
}

variable "gov_notify_status_email_template" {
  type        = "string"
  description = "Notify template ID of the status report email"
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

variable "webapp_warm_up" {
  type        = "string"
  description = "WebApp Lambda warm up flag; allowable values: true or false"
}

variable "webapp_warm_up_timeout_sec" {
  type        = "string"
  description = "WebApp Lambda warm up timeout in seconds"
}

variable "manage_cw_lg_web_lambda" {
  type        = "string"
  description = "Enable CloudWatch Log Group for MOTR WebHandler Lambda to be managed by Terraform"
}

variable "cw_lg_web_lambda_retention" {
  type        = "string"
  description = "Specifies the number of days you want to retain log events"
}

variable "tb_subscr_read_capacity" {
  type        = "string"
  description = "Table motr-subscription read capacity"
}

variable "tb_subscr_write_capacity" {
  type        = "string"
  description = "Table motr-subscription write capacity"
}

variable "tb_canc_subscr_read_capacity" {
  type        = "string"
  description = "Table motr-unsubscription-history read capacity"
}

variable "tb_canc_subscr_write_capacity" {
  type        = "string"
  description = "Table motr-unsubscription-history write capacity"
}

variable "tb_pending_subscr_read_capacity" {
  type        = "string"
  description = "Table motr-pending_subscription read capacity"
}

variable "tb_pending_subscr_write_capacity" {
  type        = "string"
  description = "Table motr-pending_subscription write capacity"
}

variable "tb_sms_confirmation_read_capacity" {
  type        = "string"
  description = "Table motr-sms_confirmation read capacity"
}

variable "tb_sms_confirmation_write_capacity" {
  type        = "string"
  description = "Table motr-sms_confirmation write capacity"
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

variable "ix_canc_subscr_vrmg_read_capacity" {
  type        = "string"
  description = "Index vrm-gsi (motr-unsubscription-history) read capacity"
}

variable "ix_canc_subscr_vrmg_write_capacity" {
  type        = "string"
  description = "Index vrm-gsi (motr-unsubscription-history) write capacity"
}

variable "ix_canc_subscr_emailg_read_capacity" {
  type        = "string"
  description = "Index email-gsi (motr-unsubscription-history) read capacity"
}

variable "ix_canc_subscr_emailg_write_capacity" {
  type        = "string"
  description = "Index email-gsi (motr-unsubscription-history) write capacity"
}

variable "mot_test_reminder_info_api_uri" {
  type        = "string"
  description = "MOT test reminder info api uri"
}

variable "mot_api_mot_test_number_uri" {
  type        = "string"
  description = "Vehicle data by mot test number api uri"
}

variable "mot_api_dvla_id_uri" {
  type        = "string"
  description = "Vehicle data by dvla id api uri"
}

variable "mot_test_reminder_info_token" {
  type        = "string"
  description = "Auth token for getting mot test information"
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

variable "manage_cw_lg_subscr_lambda" {
  type        = "string"
  description = "Enable CloudWatch Log Group for MOTR Subscription Loader Lambda to be managed by Terraform"
}

variable "cw_lg_subscr_lambda_retention" {
  type        = "string"
  description = "Specifies the number of days you want to retain log events"
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

variable "MotrBouncingEmailCleaner_s3_key" {
  type        = "string"
  description = "MotrBouncingEmailCleaner Lambda Handler S3 key"
}

variable "MotrBouncingEmailCleaner_ver" {
  type        = "string"
  description = "MotrBouncingEmailCleaner Lambda version"
}

variable "MotrBouncingEmailCleaner_publish" {
  type        = "string"
  description = "MotrBouncingEmailCleaner Lambda publish switch"
}

variable "MotrBouncingEmailCleaner_mem_size" {
  type        = "string"
  description = "Amount of memory in MB Lambda Function can use at runtime"
}

variable "MotrBouncingEmailCleaner_timeout" {
  type        = "string"
  description = "The amount of time Lambda Function has to run in seconds"
}

variable "bouncing_email_cleaner_log_level" {
  type        = "string"
  description = "WebApp Lambda log level"
}

variable "manage_cw_lg_cleaner_lambda" {
  type        = "string"
  description = "Enable CloudWatch Log Group for MOTR Bouncing Email Cleaner Lambda to be managed by Terraform"
}

variable "cw_lg_cleaner_lambda_retention" {
  type        = "string"
  description = "Specifies the number of days you want to retain log events"
}

variable "motr_cleaner_schedule" {
  type        = "string"
  description = "The scheduling expression. For example, cron(0 3 * * ? *)"
}

variable "motr_cleaner_enabled" {
  type        = "string"
  description = "Whether the rule should be enabled"
}

variable "manage_cw_lg_notifier_lambda" {
  type        = "string"
  description = "Enable CloudWatch Log Group for MOTR Notifier Lambda to be managed by Terraform"
}

variable "cw_lg_notifier_lambda_retention" {
  type        = "string"
  description = "Specifies the number of days you want to retain log events"
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
  description = "Gov Notify Template ID for confirmation email"
}

variable "gov_notify_api_token" {
  type        = "string"
  description = "Gov Notify API key"
}

variable "base_url" {
  type        = "string"
  description = "MOT reminder base url"
}

variable "one_month_notification_template_id" {
  type        = "string"
  description = "Gov Notify Template ID for one month reminder email"
}

variable "two_week_notification_template_id" {
  type        = "string"
  description = "Gov Notify Template ID for two week reminder email"
}

variable "one_day_after_notification_template_id" {
  type        = "string"
  description = "Gov Notify Template ID for one day after reminder email"
}

variable "sms_one_month_notification_template_id" {
  type        = "string"
  description = "Gov Notify Template ID for one month reminder SMS"
}

variable "sms_two_week_notification_template_id" {
  type        = "string"
  description = "Gov Notify Template ID for two week reminder SMS"
}

variable "sms_one_day_after_notification_template_id" {
  type        = "string"
  description = "Gov Notify Template ID for one day after reminder SMS"
}

variable "confirm_email_notification_template_id" {
  type        = "string"
  description = "Gov Notify Template ID for user email confirmation"
}

variable "sms_confirm_phone_template_id" {
  type        = "string"
  description = "Gov Notify Template ID for confirm phone SMS"
}

variable "sms_confirmation_template_id" {
  type        = "string"
  description = "Gov Notify Template ID for subscription confirmation SMS"
}

variable "inflight_batches_loader" {
  type        = "string"
  description = "The maximum number of concurrent message batches that can be put on the Amazon SQS queue"
}

variable "post_purge_delay_loader" {
  type        = "string"
  description = "Amount of time to wait while purging of the Amazon SQS queue"
}

variable "worker_count_notifier" {
  type        = "string"
  description = "Number of threads for subscription processing in the Notifier lambda"
}

variable "message_visibility_timeout_notifier" {
  type        = "string"
  description = "Length of time in seconds before a read message becomes visible again on queue"
}

variable "vehicle_api_client_timeout_notifier" {
  type        = "string"
  description = "Timeout in seconds of the call to the vehicle api within the notifier"
}

variable "mot_test_reminder_info_api_client_read_timeout" {
  type        = "string"
  description = "Read timeout in seconds of the call to the vehicle api within the web app"
}

variable "mot_test_reminder_info_api_client_connection_timeout" {
  type        = "string"
  description = "Connection timeout in seconds of the call to the vehicle api within the web app"
}

variable "message_receive_timeout_notifier" {
  type        = "string"
  description = "Timeout in seconds of the call to the queue for each batch of subscription messages"
}

variable "remaining_time_threshold_notifier" {
  type        = "string"
  description = "The threshold for the lambda remaining time the notifier uses to cease further message processing"
}

variable "kms_key_arn" {
  type        = "string"
  description = "KMS key ARN"
}

variable "web_enable_warmup" {
  type        = "string"
  description = "Enable WebLambda for WarmUp"
}

variable "web_warmup_rate" {
  type        = "string"
  description = "Web WarmUp rate"
}

variable "NPinger_publish" {
  type        = "string"
  description = "NPinger lambda publish switch"
}

variable "NPinger_mem_size" {
  type        = "string"
  description = "NPinger memory size in MB"
}

variable "NPinger_timeout" {
  type        = "string"
  description = "NPinger lambda timout in seconds"
}

variable "NPinger_ver" {
  type        = "string"
  description = "NPinger lambda timout in seconds"
}

variable "NPinger_concurrent_target_count" {
  type        = "string"
  description = "NPinger number of target executions"
}

variable "NPinger_payload" {
  type        = "string"
  description = "NPinger payload to be sent to the target lambda"
}

variable "NPinger_lambda_filename" {
  type        = "string"
  description = "NPinger lambda filename"
}

variable "manage_cw_lg_npinger_lambda" {
  type        = "string"
  description = "Enable CloudWatch Log Group for MOTR pinger Lambda to be managed by Terraform"
}

variable "cw_lg_npinger_lambda_retention" {
  type        = "string"
  description = "Specifies the number of days you want to retain log events"
}

variable "feature_toggle_sms" {
  type        = "string"
  description = "Whether to enable the SMS features of MOTR"
}

variable "release_version" {
  type        = "string"
  description = "The version of the current release - will be changed on every release through the environment variables"
}

variable "MotrSmsReceiver_s3_key" {
  type        = "string"
  description = "SmsReceiver Lambda Handler S3 key"
}

variable "MotrSmsReceiver_ver" {
  type        = "string"
  description = "SmsReceiver Lambda version"
}

variable "MotrSmsReceiver_publish" {
  type        = "string"
  description = "SmsReceiver Lambda publish switch"
}

variable "MotrSmsReceiver_mem_size" {
  type        = "string"
  description = "Amount of memory in MB Lambda Function can use at runtime"
}

variable "MotrSmsReceiver_timeout" {
  type        = "string"
  description = "The amount of time Lambda Function has to run in seconds"
}

variable "manage_cw_lg_sms_receiver_lambda" {
  type        = "string"
  description = "Enable CloudWatch Log Group for MOTR SmsReceiver Lambda to be managed by Terraform"
}

variable "cw_lg_sms_receiver_lambda_retention" {
  type        = "string"
  description = "Specifies the number of days you want to retain log events"
}

variable "sms_receiver_log_level" {
  type        = "string"
  description = "MOTR SmsReceiver lambda log level"
}

variable "sms_receiver_notify_bearer_token" {
  type        = "string"
  description = "MOTR SmsReceiver encrypted version of GOV Notify token"
}

variable "sms_receiver_notify_token" {
  type        = "string"
  description = "MOTR SmsReceiver token received from GOV Notify, verified by lambda"
}

variable "sms_receiver_alias_record" {
  type        = "string"
  description = "DNS alias record name for SMS Receiver"
}
