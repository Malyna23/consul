resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = ["${var.subnet}"]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = ""
  username             = ""
  password             = ""
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = "${aws_db_subnet_group.default.id}"
  security_group_names = ["${var.security_group}"]
  
}