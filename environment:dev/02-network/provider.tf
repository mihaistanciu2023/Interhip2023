terraform {

  required_version = ">= 0.13.0"

  backend "s3" {
    # Replace this with your bucket name!
    bucket         = var.mihai-intership_bucket
    key            = "02-network.tf"
    region         = "eu-central-1"
  
  }
}