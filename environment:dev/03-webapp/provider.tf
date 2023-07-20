terraform {

  required_version = ">= 0.13.0"

  backend "s3" {
    # Replace this with your bucket name!
    bucket         = var.mihai_intership_bucket
    key            = "03-webapp.tfstate"
    region         = "eu-central-1"

  }
}