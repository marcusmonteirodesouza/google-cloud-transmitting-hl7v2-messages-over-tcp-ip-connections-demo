data "google_project" "project" {
}

resource "google_project_service_identity" "healthcare_sa" {
  provider = google-beta
  project  = data.google_project.project.project_id
  service  = "healthcare.googleapis.com"
}