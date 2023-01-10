resource "dog_group" "test_qa" {
  description = ""
  name = "test_qa"
  profile_name = "test_qa"
  profile_version = "latest"
  ec2_security_group_ids = [
  ]
  provider = dog.docker
}
