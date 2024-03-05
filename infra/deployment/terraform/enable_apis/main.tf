locals {
  enable_apis = [
    "artifactregistry.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "healthcare.googleapis.com",
    "pubsub.googleapis.com",
    "run.googleapis.com"
  ]
}

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

resource "google_project_service" "enable_apis" {
  for_each                   = toset(local.enable_apis)
  service                    = each.value
  disable_dependent_services = false
  disable_on_destroy         = false
}