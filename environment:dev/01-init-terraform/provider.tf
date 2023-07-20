provider "aws" {
  region = "eu-central-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_key_pair" "keys" {
  host             = "{{aws_instance.ins1_ec2.public-ip}"
  type             = "ssh"
  user             = "ec2-mihai"
  private_key      = "{file("*/Users/mihaistanciu/Desktop/aw/mihai-keys.pem")} "
  timeout          = "1m"
  }

}