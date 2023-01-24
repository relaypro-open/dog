terraform {
  required_providers {
      dog = {
      source = "relaypro-open/dog"
      version = "1.0.12"
    }
  }
}

module "dog" {
  source        = "./dog"
  api_key       = var.dog_api_key_docker
  api_endpoint  = var.dog_api_endpoint
}
