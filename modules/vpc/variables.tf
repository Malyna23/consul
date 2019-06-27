variable "vpc_cidr" { default = "10.0.0.0/16" }
variable "consul_subnet_cidr1" { default = ["10.0.10.0/24", "10.0.11.0/24"] }
variable "subnet_databases_cidr" { default = "10.0.0.0/16" }
variable "availability_zone" { default = ["eu-central-1a", "eu-central-1b"] }
