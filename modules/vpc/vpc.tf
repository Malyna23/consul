resource "aws_vpc" "consul" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "vpc_consul"
  }
}

resource "aws_subnet" "consul_1" {
  count                   = "2"
  vpc_id                  = "${aws_vpc.consul.id}"
  cidr_block              = "${element(var.consul_subnet_cidr1, count.index)}"
  availability_zone       = "${element(var.availability_zone, count.index)}"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_consul-${count.index}"
  }
}

resource "aws_subnet" "databases" {
  count                   = "2"
  vpc_id                  = "${aws_vpc.consul.id}"
  cidr_block              = "${cidrsubnet(var.subnet_databases_cidr, 8, count.index + 1)}"
  availability_zone       = "${element(var.availability_zone, count.index)}"
  

  tags = {
    Name = "subnet_databases-${count.index}"
  }
}

resource "aws_internet_gateway" "consul" {
  vpc_id = "${aws_vpc.consul.id}"

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.consul.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.consul.id}"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.consul.id}"

  ingress {
    # TLS (change to whatever ports you need)
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    # TLS (change to whatever ports you need)
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"

    # Please restrict your ingress to only necessary IPs and ports.

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    # prefix_list_ids = ["pl-12c4e678"]
  }
}
