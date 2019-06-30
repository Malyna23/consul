resource "aws_instance" "instance" {
  count             = "${var.count_consul}"
  instance_type     = "${var.instance_type}"
  ami               = "${var.ami}"
  availability_zone = "${element(var.availability_zone, count.index)}"
  subnet_id         = "${element(var.vpc_network, count.index)}"
  security_groups   = ["${var.security_group}"]
  key_name          = "consul"

  tags = {
    Name = "${var.name}-${count.index}"
    consul = "server"
  }
}

