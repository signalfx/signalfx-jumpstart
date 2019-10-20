provider "signalfx" {
  auth_token = "${var.access_token}"
  api_url    = "https://api.${var.realm}.signalfx.com"
}

module "aws" {
  source = "./aws"
}

module "host" {
  source = "./host"
}

module "azure" {
  source = "./azure"
}

module "docker" {
  source = "./docker"
}