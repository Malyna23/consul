ui = true
listener "tcp" {
        address          = "0.0.0.0:8200"
        cluster_address  = "0.0.0.0:8201"
        tls_disable      = "false"
        tls_cert_file = "/vault/pki/cert.pem"
        tls_key_file  = "/vault/pki/key.pem"
      }
      
      storage "consul" {
        address = "${consul_ip}:8501"
        path    = "vault/"
      }