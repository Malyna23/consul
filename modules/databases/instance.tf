resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${var.subnet}"]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = "${var.allocated_storage}"
  storage_type         = "${var.storage_type}"
  engine               = "${var.engine}"
  engine_version       = "${var.engine_version}"
  instance_class       = "${var.instance_class}"
  name                 = "${var.name}"
  username             = "${var.username}"
  password             = "${var.password}"
  parameter_group_name = "${var.parameter_group_name}"
  db_subnet_group_name = "${aws_db_subnet_group.default.id}"
  #security_group_names = ["${var.security_group}"]
}
