provider "aws" {
  region     = "us-west-2"
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

provider "http" {}
