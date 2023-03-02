resource "dog_group" "test_qa" {
  description = ""
  name = "test_qa"
  profile_id = dog_profile.test_qa.id
  profile_name = dog_profile.test_qa.name
  profile_version = "latest"
  ec2_security_group_ids = [
  ]
  provider = dog.docker
  vars = {
    "test" = "dog_group-test_qa"
  }
}

resource "dog_group" "test_group" {
  description = ""
  name = "test_group"
  profile_id = dog_profile.test_qa.id
  profile_name = dog_profile.test_qa.name
  profile_version = "latest"
  ec2_security_group_ids = [
  ]
  provider = dog.docker
  vars = {
    "test" = "dog_group-test_group"
  }
}

resource "dog_group" "local_group" {
  description = ""
  name = "local_group"
  profile_id = dog_profile.test_drew.id
  profile_name = dog_profile.test_drew.name
  profile_version = "latest"
  ec2_security_group_ids = [
  ]
  provider = dog.docker
  vars = {
    "test" = "dog_group-local_group"
  }
}
