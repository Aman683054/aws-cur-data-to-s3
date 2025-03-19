provider "aws" {
  region = "eu-west-1"
  profile = "default"

  default_tags {
    tags = {
      "app-id"    = "12345"
      "app-name"  = "cur-test"
      "managedby" = "Terraform"
      "owner"     = "Amandeep Bhatti"
    }
  }
}

terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "aws"
      version = "~> 5.0"
    }
  }
  #   backend "s3" {
  #     bucket = "aman-tf-bucket"
  #     key    = "cur/cur.tfstate"
  #     region = "eu-west-1"
  #   }
}