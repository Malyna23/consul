resource "aws_elb" "app" {
  name = "foobar-terraform-elb"

  subnets         = ["${module.vpc.consul_network}"]
  security_groups = ["${module.vpc.security_group}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/wp-admin/install.php"
    interval            = 30
  }

  instances                   = ["${module.consul_client.instance_id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "app-elb"
  }
}
