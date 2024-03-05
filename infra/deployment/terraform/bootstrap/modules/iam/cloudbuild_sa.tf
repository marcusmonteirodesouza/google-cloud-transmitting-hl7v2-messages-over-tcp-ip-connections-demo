locals {
  cloudbuild_sa_email = "${data.google_project.project.number}@cloudbuild.gserviceaccount.com"

  cloudbuild_sa_roles = [
    "roles/artifactregistry.admin",
    "roles/compute.admin",
    "roles/healthcare.datasetAdmin",
    "roles/healthcare.hl7V2StoreAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/pubsub.admin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/run.admin",
    "roles/secretmanager.admin",
    "roles/serviceusage.serviceUsageAdmin"
  ]
}

resource "google_project_iam_member" "cloudbuild_sa" {
  for_each = toset(local.cloudbuild_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${local.cloudbuild_sa_email}"
}