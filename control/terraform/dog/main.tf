terraform {
  required_providers {
    dog = {
      source = "relaypro-open/dog"
      version = ">=1.0.10"
    }
  }
}

provider "dog" {
  api_endpoint = var.api_endpoint
  api_key = var.api_key
  alias = "docker"
}
