resource "dog_zone" "test_zone" {
  name = "test_zone"
  ipv4_addresses = ["127.0.0.1"]
  ipv6_addresses = []
  provider = dog.docker
}
