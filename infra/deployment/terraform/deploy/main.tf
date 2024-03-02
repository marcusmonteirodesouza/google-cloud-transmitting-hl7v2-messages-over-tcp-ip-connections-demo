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

module "healthcare" {
  source = "./modules/healthcare"
}