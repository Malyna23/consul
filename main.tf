 module "consul" {
   source = "./modules/consul"
   version = "0.0.1"
   vpc_network = "${module.vpc.consul_network}"
   security_group = "${module.vpc.security_group}"
 }
  module "vpc" {
   source = "./modules/vpc"
   version = "0.0.1"
 }
 module "certificates" {
   source = "./modules/certificates"
   version = "0.0.1"
 }