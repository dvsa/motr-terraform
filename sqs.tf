resource "aws_sqs_queue" "MotrSubscriptionsQueue" {
  name                      = "motr-subscription-queue-${var.environment}"
  delay_seconds             = "${var.motr_subscribtion_q_delay_s}"
  max_message_size          = "${var.motr_subscribtion_q_max_msg_size}"
  message_retention_seconds = "${var.motr_subscribtion_q_msg_retention_s}"
  receive_wait_time_seconds = "${var.motr_subscribtion_q_receive_wait_s}"
}
