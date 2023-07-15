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
      name = ""
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

module "organization" {
  source = "../../modules/organization"
  environment = "mng"
}