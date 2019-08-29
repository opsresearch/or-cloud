# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "cluster" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "${var.subnet_cidr}"
  map_public_ip_on_launch = false
}

resource "aws_security_group_rule" "ssh_from_bastion" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  source_security_group_id = "${var.bastion_secgrp_id}"
  security_group_id = "${aws_security_group.cluster.id}"
}

resource "aws_security_group_rule" "http_from_bastion" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  source_security_group_id = "${var.bastion_secgrp_id}"
  security_group_id = "${aws_security_group.cluster.id}"
}

resource "aws_security_group_rule" "ssh_from_control" {
  type            = "ingress"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  source_security_group_id = "${var.control_secgrp_id}"
  security_group_id = "${aws_security_group.cluster.id}"
}

resource "aws_security_group_rule" "http_from_control" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  source_security_group_id = "${var.control_secgrp_id}"
  security_group_id = "${aws_security_group.cluster.id}"
}

resource "aws_security_group_rule" "http_from_self" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  self            = true
  security_group_id        = "${aws_security_group.cluster.id}"
}

resource "aws_security_group_rule" "all_out" {
  type            = "egress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks = ["0.0.0.0/0"]  
  security_group_id = "${aws_security_group.cluster.id}"
}

# Our security group to access
resource "aws_security_group" "cluster" {
  name        = "or-secgrp-${var.cluster_name}"
  description = "Used in the terraform"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_elb" "elb" {
  tags = {Name = "or-${var.cluster_name}"}
  name = "or-${var.cluster_name}"
  internal = true
  subnets = ["${aws_subnet.cluster.id}"]
  security_groups = ["${aws_security_group.cluster.id}"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/ping.html"
    interval            = 30
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  idle_timeout                = 400
  connection_draining         = false
  connection_draining_timeout = 400
}

resource "aws_launch_configuration" "node" {
  name_prefix     = "or-node-"
  image_id        = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name        = "${var.keypair_name}"
  security_groups = ["${aws_security_group.cluster.id}"]

  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "cluster" {
  name                        = "or-${var.cluster_name}"
  max_size                    = "${var.max_size}"
  min_size                    = "${var.min_size}"
  health_check_grace_period   = 300
  health_check_type           = "EC2"
  desired_capacity            = "${var.desired_capacity}"
  force_delete                = true
  launch_configuration        = "${aws_launch_configuration.node.name}"
  vpc_zone_identifier         = ["${aws_subnet.cluster.id}"]
  load_balancers              = ["${aws_elb.elb.id}"]

  lifecycle {
    create_before_destroy = true
  }
}



