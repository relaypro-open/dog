resource "dog_inventory" "docker" {
  name = "docker"
  groups = {
     "all" = {
       vars = {
        	key = "value"
          	key2 = "value2"
        }
     	hosts = {
          host1 = {
            key = "value",
            key2 = "value2"
          }
          host2 = {
            key2 = "value2"
          }
        },
	children = [
		"test"
	]
     },
     "app" = {
     	vars = {
        	key = "value"
        }
     	hosts = {
          host1 = {
            key = "value"
          }
        },
	children = [
		"test2"
	]
     }
  }
}

