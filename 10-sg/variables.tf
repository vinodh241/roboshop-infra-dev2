# variable "project" {
#   default = "roboshop"
# }

# variable "environment" {
#   default = "dev"
# }

# variable "forntend_sg_name" {
#   default = "frontend"

# }


# variable "forntend_sg_description" {
#   default = "created sg for frontend instance"

# }


# variable "bastion_sg_name" {
#   default = "bastion"

# }

# variable "bastion_sg_description" {
#   default = "created sg for bastion instance"

# }


# variable "mongodb_ports_vpn" {

#   default = [22, 27017]

# }

# variable "redis_ports_vpn" {

#   default = [22, 6379]

# }


# variable "mysql_ports_vpn" {

#   default = [22, 3306]

# }


# variable "rabbitmq_ports_vpn" {

#   default = [22, 5672]

# }

##########################################################################################################
## copied form daws-84 git:


variable "project" {
    default = "roboshop"
}

variable "environment" {
    default = "dev"
}

variable "frontend_sg_name" {
    default = "frontend"
}

variable "frontend_sg_description" {
    default = "created sg for frontend instance"
}

variable "bastion_sg_name" {
    default = "bastion"
}

variable "bastion_sg_description" {
    default = "created sg for bastion instance"
}

variable "mongodb_ports_vpn" { # just keep as mongodb_ports
    default = [22, 27017]
}

variable "redis_ports_vpn" {
    default = [22, 6379]
}

variable "mysql_ports_vpn" {
    default = [22, 3306]
}

variable "rabbitmq_ports_vpn" {
    default = [22, 5672]
}
