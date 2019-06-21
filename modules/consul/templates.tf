data "template_file" "vault_conf" {
  count    = "${var.count_consul}"
  template = "${file("${path.module}/templates/local.tpl")}"

  vars {
    consul_ip = "${element(aws_instance.consul_server.*.private_ip, count.index)}"
  }
}
