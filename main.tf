module "vpc" {
  source = "./modules/vpc"
}

module "consul" {
  source         = "./modules/consul"
  count_consul   = "${var.count_consul}"
  vpc_network    = "${module.vpc.consul_network}"
  security_group = "${module.vpc.security_group}"
}

module "consul_certificates" {
  source          = "./modules/certificates"
  certs_count     = "${var.count_consul}"
  private_key_pem = "${module.ca.ca_private_key_pem}"
  ca_cert_pem     = "${module.ca.ca_cert_pem}"
  private_dns     = "${module.consul.private_dns}"
  private_ip_all  = "${module.consul.private_ip_all}"
}

module "ca" {
  source = "./modules/ca"
}

module "databases" {
  source         = "./modules/databases"
  subnet         = "${module.vpc.subnet_databases}"
  security_group = "${module.vpc.security_group}"
}
