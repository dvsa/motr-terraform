data "template_file" "apig_assumerole_policy" {
  template = "${file("${path.module}/iam_policies/apig_assumerole_policy.json.tpl")}"
}

resource "aws_iam_role" "APIGateway" {
  name               = "motr-web-${var.environment}"
  assume_role_policy = "${data.template_file.apig_assumerole_policy.rendered}"
}
