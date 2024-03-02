provider "google" {
  project               = var.project_id
  region                = "northamerica-northeast1"
  user_project_override = true
}

provider "google-beta" {
  project               = var.project_id
  region                = "northamerica-northeast1"
  user_project_override = true
}

module "iam" {
  source = "./modules/iam"
}

module "network" {
  source = "./modules/network"
}

module "healthcare" {
  source = "./modules/healthcare"
}

module "mllp_adapter" {
  source = "./modules/mllp_adapter"

  northamerica_northeast1_subnetwork_name = module.network.vpc_northamerica_northeast1_subnetwork
}