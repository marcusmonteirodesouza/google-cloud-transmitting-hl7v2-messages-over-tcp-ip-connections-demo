module "mllp_adapter_gce_container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 3.1"

  container = {
    image = "cloud-healthcare-containers/mllp-adapter:latest"
  }

  restart_policy = "Always"
}

resource "google_compute_instance" "mllp_adapter" {
  name         = "mllp-adapter"
  machine_type = "n2-standard-2"
  zone         = "northamerica-northeast1-a"

  boot_disk {
    initialize_params {
      image = module.mllp_adapter_gce_container.source_image
    }
  }

  network_interface {
    subnetwork = var.northamerica_northeast1_subnetwork_name
  }

  shielded_instance_config {
    enable_secure_boot = true
  }

  metadata = {
    gce-container-declaration = module.mllp_adapter_gce_container.metadata_value
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
    block-project-ssh-keys    = true
    enable-oslogin            = true
  }

  labels = {
    container-vm = module.mllp_adapter_gce_container.vm_container_label
  }

  allow_stopping_for_update = true

  service_account {
    email = google_service_account.mllp_adapter.email
    scopes = [
      "cloud-platform",
    ]
  }

  depends_on = [
    google_project_iam_member.mllp_adapter_sa
  ]
}