provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "current" {}

provider "aws" {
  # us-east-1 for CF Distro certificates
  region = "us-east-1"
  alias  = "cfdistro_cert"
}
