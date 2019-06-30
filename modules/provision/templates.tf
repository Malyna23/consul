data "template_file" "vault_conf" {
  count    = "2"
  template = "${file("${path.module}/templates/local.tpl")}"

  vars {
    consul_ip = "${element(var.private_ip_all, count.index)}"
  }
}
