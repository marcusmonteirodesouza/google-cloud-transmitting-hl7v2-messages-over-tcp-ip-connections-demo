resource "google_cloud_run_v2_service" "api" {
  name     = "api"
  location = "northamerica-northeast1"
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.api.email

    containers {
      image = "${docker_registry_image.api.name}@${docker_registry_image.api.sha256_digest}"

      startup_probe {
        http_get {
          path = "/healthz"
        }
      }

      liveness_probe {
        http_get {
          path = "/healthz"
        }
      }

      env {
        name  = "GOOGLE_CLOUD_PROJECT"
        value = data.google_project.project.project_id
      }
      env {
        name  = "HL7V2_DATASET_NAME"
        value = var.hl7v2_dataset_name
      }
      env {
        name  = "HL7V2_DATASET_LOCATION"
        value = "northamerica-northeast1"
      }
      env {
        name  = "HL7V2_STORE_NAME"
        value = var.hl7v2_store_name
      }
    }
  }

  depends_on = [
    google_project_iam_member.api_sa,
    google_healthcare_hl7_v2_store_iam_member.hl7_v2_store_api_sa
  ]
}