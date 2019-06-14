output "consul_network" {
   value = "${aws_subnet.consul_1.id}"
}
output "security_group" {
   value = "${aws_security_group.allow_tls.id}"
}