terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  access_key = "fake"
  secret_key = "fake"
}

resource "null_resource" "example" {
  triggers = {
    always_run = timestamp()
  }
}
