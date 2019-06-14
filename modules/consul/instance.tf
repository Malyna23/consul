resource "aws_key_pair" "consul_cluster" {
  key_name   = "consul_cluster"
  public_key = ""
}

resource "aws_instance" "consul_server" {
  count             = "${var.count_consul}"
  instance_type     = "${var.instance_type}"
  ami               = "${var.ami}"
  availability_zone = "${var.availability_zone}"
  subnet_id         = "${var.vpc_network}"
  security_groups   = ["${var.security_group}"]
  key_name          = "${aws_key_pair.consul_cluster.id}"

  tags = {
    Name = "consul-server-${count.index}"
  }
}

resource "null_resource" consul_cluster {
  depends_on = ["aws_instance.consul_server"]
  count      = 2

  connection {
    host        = "${element(aws_instance.consul_server.*.public_ip, count.index)}"
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("${var.aws_pem_key_file_path}")}"
  }

  provisioner "file" {
    source      = "keys"
    destination = "/home/ubuntu/keys"
  }
    provisioner "file" {
    source      = "modules/consul/templates/config.json"
    destination = "/home/ubuntu/config.json"
  }

  provisioner "remote-exec" {
    inline = [<<EOF
          sudo apt-get -y update
          sudo apt -y update
          sudo apt -y install docker.io
          IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
          echo "Instance IP is: $IP"
          sudo docker run -d -v /home/ubuntu/keys:/var/pki -p 8500:8500 --net=host \
    --name=consul \
    consul agent -server -ui \
    -bind="$IP" -retry-join="${aws_instance.consul_server.0.private_ip}" \
    -client="0.0.0.0" \
    -bootstrap-expect="${var.count_consul}"
    sudo docker cp /home/ubuntu/config.json consul:/consul/config
    sudo docker restart consul
          EOF
    ]
  }
}
