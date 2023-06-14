terraform {
  required_providers {
    dog = {
      source = "relaypro-open/dog"
      version = ">=1.0.24"
    }
  }
}

provider "dog" {
  api_endpoint = var.api_endpoint
  api_token = var.api_token
  alias = "docker"
}
