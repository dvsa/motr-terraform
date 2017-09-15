provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  # us-east-1 for CF Distro certificates
  region = "us-east-1"
  alias  = "cfdistro_cert"
}
