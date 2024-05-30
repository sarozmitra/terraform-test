terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.51.1"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

variable "subnet_cider_block" {
  description = "subnet cider block"
}

variable "vpc_cider_block" {
  description = "vpc cider block"
}

resource "aws_vpc" "development-vpc" {
  cidr_block = var.vpc_cider_block
  tags = {
    Name : "development"
    vpc_env : "dev"
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id            = aws_vpc.development-vpc.id
  cidr_block        = var.subnet_cider_block
  availability_zone = "eu-west-2a"
  tags = {
    Name : "subnet-1-dev"
  }
}

data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "172.31.48.0/20"
  availability_zone = "eu-west-2a"
  tags = {
    Name : "subnet-2-default"
  }
}
