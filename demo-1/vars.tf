variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}

variable "AWS_PROVIDER_VERSION" {
  default = "~> 1.3"
}

variable "AWS_REGION" {
  default = "eu-west-1"
}

variable "AMIS" {
  type = "map"

  default = {
    us-east-1 = "ami-04169656fea786776"
    eu-west-2 = "ami-c7ab5fa0"
    eu-west-1 = "ami-0181f8d9b6f098ec4"
  }
}
