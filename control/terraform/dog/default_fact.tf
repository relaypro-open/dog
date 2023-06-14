resource "dog_fact" "docker" {
  name = "docker"
  groups = {
    "all" = {
      vars = {
        key = "value"
        key2 = "value2"
      },
      "children" = [],
      "hosts" = {}
    }
  }
}

