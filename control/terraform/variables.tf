variable "dog_api_key_docker" {
  type = string
  sensitive = true
}

variable "dog_api_endpoint" {
  default = "http://kong:8000/api/V2"
}
