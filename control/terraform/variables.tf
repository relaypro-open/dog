variable "dog_api_token_docker" {
  type = string
  sensitive = true
}

variable "dog_api_endpoint" {
  default = "http://kong:8000/api/V2"
}
