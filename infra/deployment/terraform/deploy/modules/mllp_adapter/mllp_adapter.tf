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

resource "google_compute_address" "mllp_adapter" {
  name         = "mllp-adapter-address"
  region       = "northamerica-northeast1"
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork_northamerica_northeast1_name
}

module "mllp_adapter_gce_container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 3.1"

  container = {
    image = "gcr.io/cloud-healthcare-containers/mllp-adapter:latest"

    command = [
      "/usr/mllp_adapter/mllp_adapter"
    ]

    args = [
      "--port=2575",
      "--hl7_v2_project_id=${data.google_project.project.project_id}",
      "--hl7_v2_location_id=northamerica-northeast1",
      "--hl7_v2_dataset_id=${var.hl7_v2_dataset_name}",
      "--hl7_v2_store_id=${var.hl7_v2_store_name}",
      "--logtostderr",
      "--receiver_ip=0.0.0.0"
    ]
  }

  restart_policy = "Always"
}

resource "google_compute_instance" "mllp_adapter" {
  # Force re-creation when GCE Container Metadata Value changes.
  name         = "mllp-adapter-${md5(module.mllp_adapter_gce_container.metadata_value)}"
  machine_type = "n2-standard-2"
  zone         = "northamerica-northeast1-a"

  boot_disk {
    initialize_params {
      image = module.mllp_adapter_gce_container.source_image
    }
  }

  network_interface {
    subnetwork = var.subnetwork_northamerica_northeast1_name
    network_ip = google_compute_address.mllp_adapter.address
  }

  tags = [
    "allow-ingress-mllp"
  ]

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
    google_project_iam_member.mllp_adapter_sa,
    google_healthcare_dataset_iam_member.hl7_v2_dataset
  ]
}