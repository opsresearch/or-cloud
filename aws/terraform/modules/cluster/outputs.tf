output "secgrp_id" {
  value = "${aws_security_group.cluster.id}"
}
output "dns_name" {
  value = "${aws_elb.elb.dns_name}"
}