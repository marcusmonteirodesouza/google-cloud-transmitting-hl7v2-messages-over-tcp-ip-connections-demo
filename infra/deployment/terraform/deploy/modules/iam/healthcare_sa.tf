locals {
  healthcare_sa_roles = [
    "roles/pubsub.publisher"
  ]
}

resource "google_project_service_identity" "healthcare_sa" {
  provider = google-beta
  project  = data.google_project.project.project_id
  service  = "healthcare.googleapis.com"
}

resource "google_project_iam_member" "healthcare_sa" {
  for_each = toset(local.healthcare_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_project_service_identity.healthcare_sa.email}"
}