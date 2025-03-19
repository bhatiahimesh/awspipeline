terraform {
  backend "s3" {
    bucket = "aws-cicd-pipeline-ds1"
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
}