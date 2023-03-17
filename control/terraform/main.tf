terraform {
  required_providers {
    dog = {
      source = "relaypro-open/dog"
      version = "1.0.21"
    }
  }
}

module "dog" {
  source        = "./dog"
  api_token     = var.dog_api_token_docker
  api_endpoint  = var.dog_api_endpoint
}
