# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "control" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.subnet_cidr}"
  map_public_ip_on_launch = true
}

resource "aws_security_group_rule" "ssh_from_bastion" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  source_security_group_id = "${var.bastion_secgrp_id}"
  security_group_id = "${aws_security_group.control.id}"
}

resource "aws_security_group_rule" "http_from_bastion" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  source_security_group_id = "${var.bastion_secgrp_id}"
  security_group_id = "${aws_security_group.control.id}"
}

# Our security group to access
resource "aws_security_group" "control" {
  name        = "or-secgrp-control"
  description = "Used in the terraform"
  vpc_id      = "${var.vpc_id}"

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "control" {
  tags = {Name = "or-control"}
  associate_public_ip_address = true
  instance_type = "${var.instance_type}"
  ami = "${var.ami}"
  key_name = "${var.keypair_name}"
  subnet_id = "${aws_subnet.control.id}"
  vpc_security_group_ids = ["${aws_security_group.control.id}"]
}
