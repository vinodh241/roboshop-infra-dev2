module "forntend" {
  # source         = "../../terraform-aws-sggroup2"
  source = "git::https://github.com/vinodh241/terraform-aws-sggroup2.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.forntend_sg_name
  sg_description = var.forntend_sg_description
  vpc_id = local.vpc_id

} 
###################################################################################################

## bastion 

module "bastion" {
  # source         = "../../terraform-aws-sggroup2"
  source = "git::https://github.com/vinodh241/terraform-aws-sggroup2.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  vpc_id = local.vpc_id

} 


## bastion accepting conections from my laptop 

resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}


#######################################################################################################

## Backend_alb 

module "backend_alb" {
  # source         = "../../terraform-aws-sggroup2"
  source = "git::https://github.com/vinodh241/terraform-aws-sggroup2.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "backend-alb"
  sg_description = "for backend_alb"
  vpc_id = local.vpc_id

} 

## backend ALB accepting conections from bastion host or port no 80  

resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend_alb.sg_id
}

##backend ALB accepting conections from VPN  host or port no 80  


resource "aws_security_group_rule" "backend_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.backend_alb.sg_id


}



###################################################################################################################


## OpenVPN modules 

module "vpn" {
  # source         = "../../terraform-aws-sggroup2"
  source = "git::https://github.com/vinodh241/terraform-aws-sggroup2.git?ref=main"
  project        = var.project
  environment    = var.environment
  sg_name        = "vpn"
  sg_description = "for vpn"
  vpc_id = local.vpc_id

} 


## VPN Ports are 22, 1194, 943 , 443 --> VPN  

resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}


resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}


resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.sg_id
}
############################################################################################################


