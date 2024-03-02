locals {
  mllp_adapter_sa_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ]
}

resource "google_service_account" "mllp_adapter" {
  account_id   = "mllp-adapter"
  display_name = "MLLP Adapter service account"
}

resource "google_project_iam_member" "mllp_adapter_sa" {
  for_each = toset(local.mllp_adapter_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.mllp_adapter.email}"
}