locals {
  public_key_filename  = "${path.root}/keys/public.pem"
  private_key_filename = "${path.root}/keys/private.pem"
  ca                   = "${path.root}/keys/ca.pem"
  cert_request_pem     = "${path.root}/keys/cert_request_pem.pem"
  cert_locally         = "${path.root}/keys/cert_locally.pem"
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

resource "local_file" "cert_request_pem" {
  content  = "${tls_cert_request.infrastructure.cert_request_pem}"
  filename = "${local.cert_request_pem}"
}

resource "local_file" "cert_locally" {
  content  = "${tls_locally_signed_cert.infrastructure.cert_pem}"
  filename = "${local.cert_locally}"
}
