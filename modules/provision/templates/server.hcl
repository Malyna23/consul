data_dir = "/etc/nomad.d"

server {
  enabled          = true
  bootstrap_expect = 2
}
consul {
  # The address to the Consul agent.
  address = "127.0.0.1:8501"

  # The service name to register the server and client with Consul.
  server_service_name = "nomad"
  client_service_name = "nomad-client"

  # Enables automatically registering the services.
  auto_advertise = true

  # Enabling the server and client to bootstrap using Consul.
  server_auto_join = true
  client_auto_join = true
}