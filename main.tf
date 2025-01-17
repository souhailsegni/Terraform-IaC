provider "aws" {
   region=var.region
}
data "aws_availability_zones" "available" {}


module "vpc_setup" {
   source                     ="./modules/vpc"

   name                       ="MyVPC-${terraform.workspace}"
   cidr_block                 ="10.0.0.0/16"

   public_subnet_cidrs       =[for i in range(2): format("10.0.%d.0/24", i +1)]
   private_subnet_cidrs      =[for i in range(2): format("10.0.%d.0/24", i +3)]

   availability_zones        =[for az in data.aws_availability_zones.available.names: az]
   
   public_subnet_count       =2 
   private_subnet_count      =2 

   http_port                 ="80"
   https_port                ="443"
}
module "ec2_instances" {
    source             = "./modules/ec2"
    
    public_subnet_ids  = module.vpc_setup.public_subnets_ids # Pass public subnet IDs from VPC module.
    ec2_ami            = var.ec2_ami                         # AMI ID from variables.
    instance_type = terraform.workspace == "prod" ? "t3.micro" : "t2.micro"                 # Instance type from variables.
    key_name           = var.key_name                        # Key name from variables.
    security_group     = module.vpc_setup.public_sg_id   # Security group ID from VPC module.
}
terraform {
  backend "s3" {
    bucket         = "s3-bucket-terraform-1"
    key            = "Terraform/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"  # for lock
  }
}
