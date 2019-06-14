output "private_ip" {
  value = "${aws_instance.consul_server.0.private_ip}"
}
