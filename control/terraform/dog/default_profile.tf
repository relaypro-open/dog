resource "dog_profile" "test_drew" {
  name = "test_drew"
  version = "1.0"
  provider = dog.docker
}


resource "dog_profile" "test_qa" {
  name = "test_qa"
  version = "1.0"
  provider = dog.docker
}
