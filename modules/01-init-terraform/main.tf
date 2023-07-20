locals { 
  bucket_name = "mihai-intership-bucket-${random_string.random.result}"

}

resource "random_string" "random" {
  length           = 8
  special          = false
  lower            = true
  upper            = false
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Terraform   = "True"
  }
}

#resource "aws_s3_bucket_acl" "state_bucket" {
#  bucket = aws_s3_bucket.state_bucket.id
#  acl    = "private"
#}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "mihai-intership-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}