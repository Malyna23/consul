variable "region" { default = "eu-central-1" }
variable "count_consul" { default = 2 }
variable "instance_type" { default = "t2.micro" }
variable "ami" { default = "ami-090f10efc254eaf55" }
variable "availability_zone" { default = ["eu-central-1a", "eu-central-1b"] }
