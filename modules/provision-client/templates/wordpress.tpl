job "wordpress" {
  datacenters = ["dc1"]

  group "wordpress" {
    count = 2

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"

      mode = "delay"
    }

    task "wordpress" {
      driver = "docker"
 env {
        WORDPRESS_DB_HOST = "${endpoint}"
        WORDPRESS_DB_NAME = "root"
        WORDPRESS_DB_PASSWORD = "12345678"
      }
      config {
        image = "wordpress:latest"
        port_map {
          web = 80
        }
      }

      service {
        name = "wordpress"
        port = "web"
        check {
          name = "alive"
          type = "tcp"
          interval = "10s"
          timeout = "2s"
        }
      }

      resources {
        cpu = 500 # 500 Mhz
        memory = 64 # 64MB
        network {
          mbits = 10
          port "web" {
          static = 80
          }
        }
      }
    }
  }
}
