locals {
  api_sa_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ]
}

resource "google_service_account" "api" {
  account_id   = "api-sa"
  display_name = "API service account"
}

resource "google_project_iam_member" "api_sa" {
  for_each = toset(local.api_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.api.email}"
}

resource "google_healthcare_hl7_v2_store_iam_member" "hl7_v2_store_api_sa" {
  hl7_v2_store_id = var.hl7v2_store_id
  role            = "roles/healthcare.hl7V2Consumer"
  member          = "serviceAccount:${google_service_account.api.email}"
}