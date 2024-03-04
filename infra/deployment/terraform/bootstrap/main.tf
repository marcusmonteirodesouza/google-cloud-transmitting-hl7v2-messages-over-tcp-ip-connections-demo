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

module "enable_apis" {
  source = "./modules/enable_apis"
}

module "iam" {
  source = "./modules/iam"

  depends_on = [
    module.enable_apis
  ]
}

module "cloudbuild" {
  source = "./modules/cloudbuild"

  branch_name     = var.branch_name
  sourcerepo_name = var.sourcerepo_name
  tfstate_bucket  = google_storage_bucket.tfstate.name
}

