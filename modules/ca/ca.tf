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

  allowed_uses = ["cert_signing"]

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
