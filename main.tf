provider "aws" {
  region="${var.aws_region}"
}
#Deploy storage resource
module "storage" {
  source = "./storage"
  project_name = "${var.project_name}"
  
}
#deploying networking resources
module "networking" {
source="./networking"
vpc_cidr="${var.vpc_cidr}"
public_cidrs ="${var.public_cidrs}"
accessip="${var.accessip}"
}