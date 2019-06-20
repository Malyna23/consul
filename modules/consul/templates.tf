data "template_file" "vault_conf" {
  template = "${file("${path.module}/templates/local.tpl")}"
  vars {
    consul_ip = "${element(aws_instance.consul_server.*.private_ip, count.index)}"
   
  }
}