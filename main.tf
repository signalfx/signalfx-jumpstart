provider "signalfx" {
  auth_token = var.access_token
  api_url    = "https://api.${var.realm}.signalfx.com"
}

module "aws" {
  source     = "./aws"
  sfx_prefix = var.sfx_prefix
}

module "host" {
  source     = "./host"
  sfx_prefix = var.sfx_prefix

}

module "azure" {
  source     = "./azure"
  sfx_prefix = var.sfx_prefix
}

module "docker" {
  source     = "./docker"
  sfx_prefix = var.sfx_prefix
}

module "usage_dashboard" {
  source     = "./dashboards/usage"
  sfx_prefix = var.sfx_prefix
}

module "parent_child_dashboard" {
  source     = "./dashboards/parent"
  sfx_prefix = var.sfx_prefix
}

module "gcp" {
  source     = "./gcp"
  sfx_prefix = var.sfx_prefix
}

module "kubernetes" {
  source     = "./kubernetes"
  sfx_prefix = var.sfx_prefix
}

module "pivotal" {
  source     = "./pivotal"
  sfx_prefix = var.sfx_prefix
}
