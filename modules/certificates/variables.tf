variable "private_key_pem" {}
variable "ca_cert_pem" {}

variable "private_dns" { 
  type = "list"
  default = []
 }
 variable "private_ip_all" { 
  type = "list"
  default = []
 }
 variable "certs_count" { default = 0}
variable "folder" {}