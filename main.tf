provider "aws" {
  region = var.aws_region
}

module "network" {
  source   = "./modules/network"
  vpc_cidr = var.vpc_cidr
  env      = var.env
}

module "ecs_fargate" {
  source = "./modules/ecs"
  env    = var.env
  vpc_id = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  public_subnet_ids  = module.network.public_subnet_ids
}

module "s3" {
  source = "./modules/s3"
  env    = var.env
}