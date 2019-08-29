
variable "cluster_name" {
  description = "The name of the cluster"
}

variable "max_size" {
  description = "The maximum size of the cluster"
}

variable "min_size" {
  description = "The minimum size of the cluster"
}

variable "desired_capacity" {
  description = "The initial desired size of the cluster"
}

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

variable "control_secgrp_id" {
    description = "The control security group id to allow ingress."
}

variable "bastion_secgrp_id" {
    description = "The bastion security group id to allow ingress."
}

