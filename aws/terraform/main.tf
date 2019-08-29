# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_key_pair" "auth" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

module "bastion" {
  source = "./modules/bastion"
  subnet_cidr = "10.0.1.0/24"
  instance_type = "t2.micro"

  aws_region = "${var.aws_region}"
  vpc_id = "${aws_vpc.main.id}"
  keypair_name = "${aws_key_pair.auth.id}"
  bastion_remote_cidr_blocks = "${var.bastion_remote_cidr_blocks}"
  ami = "${lookup(var.aws_amis_bastion, var.aws_region)}"
}

module "control" {
  source = "./modules/control"
  subnet_cidr = "10.0.2.0/24"
  instance_type = "t2.micro"

  aws_region = "${var.aws_region}"
  vpc_id = "${aws_vpc.main.id}"
  keypair_name = "${aws_key_pair.auth.id}"
  ami = "${lookup(var.aws_amis_control, var.aws_region)}"
  bastion_secgrp_id = "${module.bastion.secgrp_id}"
}

module "cluster-1" {
  source = "./modules/cluster"
  cluster_name = "cluster-1"
  max_size = "1"
  min_size = "1"
  desired_capacity = "1"

  subnet_cidr = "10.0.3.0/24"
  instance_type = "t2.micro"

  aws_region = "${var.aws_region}"
  vpc_id = "${aws_vpc.main.id}"
  keypair_name = "${aws_key_pair.auth.id}"
  ami = "${lookup(var.aws_amis_cluster, var.aws_region)}"
  control_secgrp_id = "${module.control.secgrp_id}"
  bastion_secgrp_id = "${module.bastion.secgrp_id}"
}

module "cluster-2" {
  source = "./modules/cluster"
  cluster_name = "cluster-2"
  max_size = "1"
  min_size = "1"
  desired_capacity = "1"

  subnet_cidr = "10.0.4.0/24"
  instance_type = "t2.micro"

  aws_region = "${var.aws_region}"
  vpc_id = "${aws_vpc.main.id}"
  keypair_name = "${aws_key_pair.auth.id}"
  ami = "${lookup(var.aws_amis_cluster, var.aws_region)}"
  control_secgrp_id = "${module.control.secgrp_id}"
  bastion_secgrp_id = "${module.bastion.secgrp_id}"
}

module "cluster-3" {
  source = "./modules/cluster"
  cluster_name = "cluster-3"
  max_size = "1"
  min_size = "1"
  desired_capacity = "1"

  subnet_cidr = "10.0.5.0/24"
  instance_type = "t2.micro"

  aws_region = "${var.aws_region}"
  vpc_id = "${aws_vpc.main.id}"
  keypair_name = "${aws_key_pair.auth.id}"
  ami = "${lookup(var.aws_amis_cluster, var.aws_region)}"
  control_secgrp_id = "${module.control.secgrp_id}"
  bastion_secgrp_id = "${module.bastion.secgrp_id}"
}

