resource "local_file" "cert_request_pem" {
  count = "4"
  content  = "${element(tls_cert_request.cert.*.cert_request_pem,count.index)}"
  filename = "${path.root}/keys/${var.folder}/${count.index}/cert_request.crt"
}

resource "local_file" "cert_locally" {
  count = "4"
  content  = "${element(tls_locally_signed_cert.cert.*.cert_pem, count.index)}"
  filename = "${path.root}/keys/${var.folder}/${count.index}/cert.pem"
}

resource "local_file" "pr_key_locally" {
  count = "4"
  content  = "${element(tls_private_key.cert.*.private_key_pem, count.index)}"
  filename = "${path.root}/keys/${var.folder}/${count.index}/key.pem"
}

resource "local_file" "pub_key_locally" {
  count = "4"
  content  = "${element(tls_private_key.cert.*.public_key_pem, count.index)}"
  filename = "${path.root}/keys/${var.folder}/${count.index}/pub.pem"
}
