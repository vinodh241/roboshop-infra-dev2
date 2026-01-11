terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.98.0"
    }
  }
  backend "s3" {
    bucket       = "vinodh-remote-state-dev"
    key          = "roboshop-dev-front-alb"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true

  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}