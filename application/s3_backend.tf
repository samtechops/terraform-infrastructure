terraform {
  backend "s3" {
    key            = "sandbox/ps/application/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
