locals {
  public_key_filename  = "${path.root}/keys/public.pem"
  private_key_filename = "${path.root}/keys/private.pem"
  ca                   = "${path.root}/keys/ca.pem"
}

resource "local_file" "public_key" {
  content  = "${tls_private_key.root.public_key_pem}"
  filename = "${local.public_key_filename}"
}

resource "local_file" "private_key_pem" {
  content  = "${tls_private_key.root.private_key_pem}"
  filename = "${local.private_key_filename}"
}

resource "local_file" "ca" {
  content  = "${tls_self_signed_cert.root.cert_pem}"
  filename = "${local.ca}"
}
