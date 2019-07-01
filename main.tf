module "vpc" {
  source = "./modules/vpc"
}

module "consul_server" {
  source            = "./modules/consul"
  name              = "consul-server"
  count_consul      = "${var.count_consul}"
  instance_type     = "${var.instance_type}"
  ami               = "${var.ami}"
  availability_zone = ["${var.availability_zone}"]
  vpc_network       = "${module.vpc.consul_network}"
  security_group    = "${module.vpc.security_group}"
}

module "consul_client" {
  source            = "./modules/consul"
  name              = "consul-client"
  count_consul      = "${var.count_consul}"
  instance_type     = "${var.instance_type}"
  ami               = "${var.ami}"
  availability_zone = ["${var.availability_zone}"]
  vpc_network       = "${module.vpc.consul_network}"
  security_group    = "${module.vpc.security_group}"
}

module "provision_server" {
  source         = "./modules/provision"
  servers        = "${var.count_consul}"
  public_ip      = "${module.consul_server.public_ip}"
  private_ip_all = "${module.consul_server.private_ip_all}"
}

module "provision_client" {
  source         = "./modules/provision-client"
  clients        = "${var.count_consul}"
  public_ip      = "${module.consul_client.public_ip}"
  private_ip_all = "${module.consul_client.private_ip_all}"
}

module "consul_certificates" {
  source          = "./modules/certificates"
  certs_count     = "${var.count_consul}"
  private_key_pem = "${module.ca.ca_private_key_pem}"
  ca_cert_pem     = "${module.ca.ca_cert_pem}"
  private_dns     = "${module.consul_server.private_dns}"
  private_ip_all  = "${module.consul_server.private_ip_all}"
}

module "consul_certificates1" {
  source          = "./modules/certificates"
  certs_count     = "${var.count_consul}"
  private_key_pem = "${module.ca.ca_private_key_pem}"
  ca_cert_pem     = "${module.ca.ca_cert_pem}"
  private_dns     = "${module.consul_client.private_dns}"
  private_ip_all  = "${module.consul_client.private_ip_all}"
}

module "ca" {
  source = "./modules/ca"
}

# module "databases" {
#   source               = "./modules/databases"
#   allocated_storage    = 20
#   storage_type         = "gp2"
#   engine               = "mysql"
#   engine_version       = "5.7"
#   instance_class       = "db.t2.micro"
#   name                 = "mydb"
#   username             = "root"
#   password             = "12345678"
#   parameter_group_name = "default.mysql5.7"
#   subnet               = "${module.vpc.subnet_databases}"
#   security_group       = "${module.vpc.security_group}"
# }

