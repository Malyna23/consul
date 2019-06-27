resource "aws_key_pair" "consul_cluster" {
  key_name   = "consul_cluster"
  public_key = ""
}

resource "aws_instance" "consul_server" {
  count             = "${var.count_consul}"
  instance_type     = "${var.instance_type}"
  ami               = "${var.ami}"
  availability_zone = "${element(var.availability_zone, count.index)}"
  subnet_id         = "${element(var.vpc_network, count.index)}"
  security_groups   = ["${var.security_group}"]
  key_name          = "${aws_key_pair.consul_cluster.id}"

  tags = {
    Name = "consul-server-${count.index}"
    consul = "server"
  }
}

resource "null_resource" consul_cluster {
  depends_on = ["aws_instance.consul_server"]
  count      = "${var.count_consul}"

  connection {
    host        = "${element(aws_instance.consul_server.*.public_ip, count.index)}"
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("${var.aws_pem_key_file_path}")}"
  }

  provisioner "file" {
    source      = "keys/${count.index}"
    destination = "/home/ubuntu/keys"
  }

  provisioner "file" {
    source      = "keys/ca.pem"
    destination = "/home/ubuntu/keys/ca.pem"
  }

  provisioner "file" {
    source      = "vault"
    destination = "/home/ubuntu/vault"
  }

  provisioner "file" {
    source      = "modules/consul/templates/config.json"
    destination = "/home/ubuntu/config.json"
  }

  provisioner "file" {
    content     = "${element(data.template_file.vault_conf.*.rendered, count.index)}"
    destination = "/home/ubuntu/vault/config/local.json"
  }

  provisioner "remote-exec" {
    inline = [<<EOF
          sudo apt-get -y update
          sudo apt -y update
          sudo apt -y install unzip
          wget https://releases.hashicorp.com/nomad/0.9.1/nomad_0.9.1_linux_amd64.zip
          unzip nomad_0.9.1_linux_amd64.zip
          sudo mv nomad /usr/local/bin/
          nomad -autocomplete-install
          complete -C /usr/local/bin/nomad nomad
          sudo apt -y install docker.io
          IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
          echo "Instance IP is: $IP"
          sudo docker run -d -v /home/ubuntu/keys:/var/pki -p 8500:8500 --net=host \
    --name=consul \
    consul agent -server -ui \
    -bind="$IP" -retry-join="provider=aws tag_key=consul tag_value=server access_key_id= secret_access_key=" \
    -client="0.0.0.0" \
    -bootstrap-expect="${var.count_consul}"
    sudo docker cp /home/ubuntu/config.json consul:/consul/config
    sudo docker restart consul
    sudo docker run -d -p 8200:8200 -v /home/ubuntu/keys:/vault/pki -v /home/ubuntu/vault:/vault --cap-add=IPC_LOCK  vault server
    

          EOF
    ]
  }
}
