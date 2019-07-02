data "template_file" "vault_conf" {
  count    = "${var.clients}"
  template = "${file("${path.module}/templates/local.tpl")}"

  vars {
    consul_ip = "${element(var.private_ip_all, count.index)}"
  }
}
data "template_file" "nomad_job" {
  template = "${file("${path.module}/templates/wordpress.tpl")}"

  vars {
    endpoint = "${var.endpoint}"
  }
}