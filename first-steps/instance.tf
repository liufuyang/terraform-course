provider "aws" {
  version    = "~> 1.3"
  access_key = ""
  secret_key = ""
  region     = "eu-west-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0181f8d9b6f098ec4"
  instance_type = "t2.micro"
  key_name      = "sunfish-eu1-ssh-key-1"
}
