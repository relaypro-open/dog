resource "dog_profile" "test_qa" {
  name = "test_qa"
  version = "1.0"
  rules = {
    inbound = [
      {
        action = "ACCEPT"
        active = "true"
        comment = "test_zone"
        environments = []
        group = "test_zone"
        group_type = "ZONE"
        interface = ""
        log = "false"
        log_prefix = ""
        order = "1"
        service = "ssh-tcp-22"
        states = []
        type = "BASIC"
      },
      {
        action = "DROP"
        active = "true"
        comment = ""
        environments = []
        group = "any"
        group_type = "ANY"
        interface = ""
        log = "false"
        log_prefix = ""
        order = "2"
        service = "any"
        states = []
        type = "BASIC"
      },
    ]
    outbound = [
      {
        action = "ACCEPT"
        active = "true"
        comment = ""
        environments = []
        group = "any"
        group_type = "ANY"
        interface = ""
        log = "false"
        log_prefix = ""
        order = "1"
        service = "any"
        states = []
        type = "BASIC"
      },
    ]
  }
  provider = dog.docker
}
