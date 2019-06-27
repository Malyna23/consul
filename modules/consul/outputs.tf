output "private_ip" {
  value = "${aws_instance.consul_server.0.private_ip}"
}
output "private_ip_all" {
  value = "${aws_instance.consul_server.*.private_ip}"
}

output "public_ip" {
  value = "${aws_instance.consul_server.*.public_ip}"
}
output "private_dns" {
  value = "${aws_instance.consul_server.*.private_dns}"
}
