variable "count_consul" { default = "2" }
variable "ami" { default = "ami-090f10efc254eaf55" }
variable "instance_type" { default = "t2.micro" }
variable "availability_zone" { default = ["eu-central-1a", "eu-central-1b"] }
variable "vpc_network" {default = []}
variable "security_group" {}
variable "aws_pem_key_file_path" { default = "./modules/consul/.ssh/id_rsa" }