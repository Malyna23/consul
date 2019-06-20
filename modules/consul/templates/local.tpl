ui = true
listener "tcp" {
        address          = "0.0.0.0:8200"
        cluster_address  = "0.0.0.0:8201"
        tls_disable      = "true"
      }
      
      storage "consul" {
        address = "${consul_ip}:8501"
        path    = "vault/"
      }