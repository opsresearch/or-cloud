
variable "subnet_cidr" {
  description = "The CIDR for the subnet"
}

variable "instance_type" {
  description = "The the user data for first-boot"
}

variable "keypair_name" {
  description = "The SSH keypair name"
}

variable "aws_region" {
  description = "AWS region to launch servers."
}

variable "vpc_id" {
  description = "AWS VPC to launch servers in."
}

variable "ami" {
  description = "The AMI to launch."
}

variable "bastion_secgrp_id" {
    description = "The bastion security group id to allow ingress."
}

