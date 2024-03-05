resource "google_secret_manager_secret" "terraform_tfvars" {
  secret_id = "terraform-tfvars"

  replication {
    user_managed {
      replicas {
        location = "northamerica-northeast1"
      }
    }
  }

  depends_on = [
    module.enable_apis
  ]
}

resource "google_secret_manager_secret_version" "terraform_tfvars" {
  secret      = google_secret_manager_secret.terraform_tfvars.id
  secret_data = file("${path.module}/terraform.tfvars")
}
