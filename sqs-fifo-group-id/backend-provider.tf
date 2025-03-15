terraform { 
  backend "s3" {
    
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.76.0"
    }
  }

  required_version = ">= 1.9.8"
}

provider "aws" {
  profile = "default"
  region = var.aws_region
}