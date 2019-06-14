resource "tls_private_key" "root" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "tls_self_signed_cert" "root" {
  key_algorithm   = "ECDSA"
  private_key_pem = "${tls_private_key.root.private_key_pem}"

  validity_period_hours = 26280
  early_renewal_hours   = 8760

  is_ca_certificate = true

  allowed_uses = ["cert_signing", "client_auth", "server_auth"]

  subject {
    common_name         = "Consul. Root"
    organization        = "Consul, Inc"
    organizational_unit = "Department of Certificate Authority"
    street_address      = ["5879 Cotton Link"]
    locality            = "Pirate Harbor"
    province            = "CA"
    country             = "US"
    postal_code         = "95559-1227"
  }
}

resource "tls_cert_request" "infrastructure" {
  key_algorithm   = "${tls_private_key.root.algorithm}"
  private_key_pem = "${tls_private_key.root.private_key_pem}"

  subject {
    common_name = "*.eu-central-1.compute.amazonaws.com"

    organization        = "Consul, Inc"
    organizational_unit = "Tech Ops Dept"
  }

  dns_names    = ["*.eu-central-1.compute.amazonaws.com"]
  ip_addresses = ["127.0.0.1", "0.0.0.0"]
}

resource "tls_locally_signed_cert" "infrastructure" {
  cert_request_pem = "${tls_cert_request.infrastructure.cert_request_pem}"

  ca_key_algorithm   = "${tls_private_key.root.algorithm}"
  ca_private_key_pem = "${tls_private_key.root.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.root.cert_pem}"
  is_ca_certificate = true
  validity_period_hours = 17520
  early_renewal_hours   = 8760

  allowed_uses = ["server_auth", "cert_signing", "client_auth"]
}
