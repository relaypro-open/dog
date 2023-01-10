resource "dog_service" "ssh-tcp-22" {
  name = "ssh-tcp-22"
  version = "1"
  services = [
      {
        protocol = "tcp"
        ports = ["22"]
      },
  ]
  provider = dog.docker
}
