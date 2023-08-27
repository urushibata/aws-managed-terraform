terraform {
  required_version = "~> 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.8.0"
    }
  }
  cloud {
    organization = "urushibata-org"
    workspaces {
      name = "urushibata-aws-management"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      ManagedBy = "terraform"
    }
  }
}