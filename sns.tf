resource "aws_sns_topic" "MotrOpsGenieAlarm_sns_topic" {
  name = "${var.project}-${var.environment}-OpsGenie-Alarm-topic"
}

resource "aws_sns_topic" "MotrServiceNowAlarm_sns_topic" {
  name = "${var.project}-${var.environment}-ServiceNow-Alarm-topic"
}

resource "aws_sns_topic_subscription" "MotrOpsGenieAlarm_sns_topic_subscription" {
  count                   = "${var.ops_genie_sns_topic_sub_create ? 1 : 0}"
  topic_arn               = "${aws_sns_topic.MotrOpsGenieAlarm_sns_topic.arn}"
  protocol                = "${var.ops_genie_sns_topic_sub_protocol}"
  endpoint                = "${var.ops_genie_sns_topic_sub_endpoint}"
  endpoint_auto_confirms  = "true"
}