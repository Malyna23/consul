resource "tls_private_key" "cert" {
  count = "${var.certs_count}"
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "tls_cert_request" "cert" {
  count = "${var.certs_count}"
  key_algorithm   = "ECDSA"
  private_key_pem = "${element(tls_private_key.cert.*.private_key_pem,count.index)}"

  subject {
    common_name = "${element(var.private_dns, count.index)}"
    organization        = "Consul, Inc"
    organizational_unit = "Tech Ops Dept"
  }

  dns_names    = ["${element(var.private_dns, count.index)}"]
  ip_addresses = ["${element(var.private_ip_all, count.index)}"]
}

resource "tls_locally_signed_cert" "cert" {
  count = "${var.certs_count}"
  cert_request_pem = "${element(tls_cert_request.cert.*.cert_request_pem,count.index)}"

  ca_key_algorithm   = "ECDSA"
  ca_private_key_pem = "${var.private_key_pem}"
  ca_cert_pem        = "${var.ca_cert_pem}"
  is_ca_certificate = true

  validity_period_hours = 17520
  early_renewal_hours   = 8760

  allowed_uses = ["server_auth", "client_auth"]
}
