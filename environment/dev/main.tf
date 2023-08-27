locals {
  environment = "dev"
}

module "vpc" {
  source      = "../../modules/vpc"
  environment = local.environment
  vpc_cidr    = "192.168.0.0/24"
}
