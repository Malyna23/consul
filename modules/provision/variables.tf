variable "servers" {}
variable "aws_pem_key_file_path" { default = "./modules/provision/consul.pem" }
variable "public_ip" { 
  type = "list"
  default = []
 }
 variable "private_ip_all" { 
  type = "list"
  default = []
 }
 variable "folder" {}