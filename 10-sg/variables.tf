variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "forntend_sg_name" {
  default = "frontend"

}


variable "forntend_sg_description" {
  default = "created sg for frontend instance"

}


variable "bastion_sg_name" {
  default = "bastion"

}

variable "bastion_sg_description" {
  default = "created sg for bastion instance"

}