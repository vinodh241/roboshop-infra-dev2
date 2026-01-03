module "vpc" {
  #source = "../terraform-aws-vpc2"  ## if your code is in your local use this 
  #   project             = "roboshop"
  #   environment         = "dev"
  #   public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

  source = "git::https://github.com/vinodh241/terraform-aws-vpc2.git?ref=main"

  project               = var.project
  environment           = var.environment
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  is_peering_required = true
}


output "vpc_ids" {
  value = module.vpc.public_subent_ids
  
}