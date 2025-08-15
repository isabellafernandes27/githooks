# Define the required providers and their versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS provider with a specific region
provider "aws" {
  region = "us-east-1"
}

# Configure AWS provider profile 
provider "aws" {
  #alias   = "org-np"
  region  = "us-east-1"
  profile = "terraform-tutorial-np"
}