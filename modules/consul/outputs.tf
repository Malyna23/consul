output "private_ip" {
  value = "${aws_instance.instance.0.private_ip}"
}
output "private_ip_all" {
  value = "${aws_instance.instance.*.private_ip}"
}

output "public_ip" {
  value = "${aws_instance.instance.*.public_ip}"
}
output "private_dns" {
  value = "${aws_instance.instance.*.private_dns}"
}
output "instance_id" {
  value = "${aws_instance.instance.*.id}"
}
