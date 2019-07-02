resource "null_resource" consul_client {
  count      = "${var.clients}"

  connection {
    host        = "${element(var.public_ip, count.index)}"
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("./modules/provision/consul.pem")}"
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
    source      = "modules/provision-client/templates/config-client.json"
    destination = "/home/ubuntu/config.json"
  }
  provisioner "file" {
    source      = "modules/provision-client/templates/client.hcl"
    destination = "/home/ubuntu/client.hcl"
  }
  provisioner "file" {
    source      = "modules/provision-client/templates/nomad.service"
    destination = "/home/ubuntu/nomad.service"
  }

  provisioner "file" {
    content     = "${element(data.template_file.vault_conf.*.rendered, count.index)}"
    destination = "/home/ubuntu/vault/config/local.json"
  }
  provisioner "file" {
    content     = "${data.template_file.nomad_job.rendered}"
    destination = "/home/ubuntu/nomad.conf"
  }

  provisioner "remote-exec" {
    inline = [<<EOF
          sudo apt-get -y update
          sudo apt -y update
          sudo apt -y install unzip
          sudo cp nomad.service /etc/systemd/system/
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
    consul agent -ui \
    -bind="$IP" -retry-join="provider=aws tag_key=consul tag_value=server access_key_id= secret_access_key=" \
    -client="0.0.0.0"
    sudo docker cp /home/ubuntu/config.json consul:/consul/config/
    sudo docker restart consul
    sudo docker run -d -p 8200:8200 -v /home/ubuntu/keys:/vault/pki -v /home/ubuntu/vault:/vault --cap-add=IPC_LOCK  vault server
    sudo systemctl start nomad.service
   


          EOF
    ]
  }
}
resource "null_resource" job {
 depends_on = ["null_resource.consul_client"]
  connection {
    host        = "${element(var.public_ip, 0)}"
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${file("./modules/provision/consul.pem")}"
  }
   provisioner "remote-exec" {
    inline = [<<EOF
         sudo nomad job run nomad.conf


          EOF
    ]
  }
}