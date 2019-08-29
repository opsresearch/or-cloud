
variable "public_key_path" {
  description = "Path to a local SSH public key for authentication."
  default = "~/.ssh/id_rsa.pub"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "or-cloud"
}

variable "bastion_remote_cidr_blocks" {
  description = "CIDR blocks to allow admin ssh access."
  default = ["0.0.0.0/0"]
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-east-1"
}

variable "aws_amis_bastion" {
  description = "The bastion AMI to launch in each region."
}
variable "aws_amis_control" {
  description = "The control AMI to launch in each region."
}
variable "aws_amis_cluster" {
  description = "The cluster AMI to launch in each region."
}