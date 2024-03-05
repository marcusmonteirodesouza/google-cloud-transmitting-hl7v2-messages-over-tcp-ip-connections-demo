resource "google_healthcare_dataset_iam_member" "hl7_v2_dataset" {
  dataset_id = var.hl7_v2_dataset_id
  role       = "roles/healthcare.hl7V2Ingest"
  member     = "serviceAccount:${google_service_account.mllp_adapter.email}"
}