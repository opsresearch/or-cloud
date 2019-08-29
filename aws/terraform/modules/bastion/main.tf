# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "bastion" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.subnet_cidr}"
  map_public_ip_on_launch = true
}

# Our security group to access
resource "aws_security_group" "bastion" {
  name        = "or-secgrp-bastion"
  description = "Used in the terraform"
  vpc_id      = "${var.vpc_id}"

  # SSH access from CIDR list
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.bastion_remote_cidr_blocks}"
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  tags = {Name = "or-bastion"}
  associate_public_ip_address = true
  instance_type = "${var.instance_type}"
  ami = "${var.ami}"
  key_name = "${var.keypair_name}"
  subnet_id = "${aws_subnet.bastion.id}"
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
}