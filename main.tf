terraform {
  required_version = ">=0.12"
  backend "s3" {
    bucket = "myapp-bucket-terraform-state"
    key    = "myapp/state.tfstate"
    region = "eu-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "myapp-vpc"
  cidr = var.vpc_cider_block

  azs                = [var.avail_zone]
  public_subnets     = [var.subnet_cider_block]
  public_subnet_tags = { Name = "${var.env_prefix}-subnet-1" }

  tags = {
    Name : "${var.env_prefix}-vpc"
  }
}

module "myapp-server" {
  source              = "./modules/webserver"
  vpc_id              = module.vpc.vpc_id
  image_name          = var.image_name
  public_key_location = var.public_key_location
  instance_type       = var.instance_type
  subnet_id           = module.vpc.public_subnets[0]
  my_ip               = var.my_ip
  env_prefix          = var.env_prefix
  avail_zone          = var.avail_zone
}
