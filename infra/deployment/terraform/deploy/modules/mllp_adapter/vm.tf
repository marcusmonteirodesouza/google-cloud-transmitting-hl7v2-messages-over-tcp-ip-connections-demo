resource "google_compute_address" "mllp_adapter" {
  name         = "mllp-adapter-address"
  address_type = "INTERNAL"
  subnetwork   = var.northamerica_northeast1_subnetwork_name
}

module "mllp_adapter_gce_container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 3.1"

  container = {
    command = "/usr/mllp_adapter/mllp_adapter --port=2575 --hl7_v2_project_id=${data.google_project.project.project_id} --hl7_v2_location_id=northamerica-northeast1 --hl7_v2_dataset_id=${var.hl7_v2_dataset_name} --hl7_v2_store_id=${var.hl7_v2_store_name} --api_addr_prefix=https://healthcare.googleapis.com:443/v1 --logtostderr --receiver_ip=0.0.0.0"
    image   = "cloud-healthcare-containers/mllp-adapter:latest"
  }

  restart_policy = "Always"
}

# TODO(Marcus): Add to mllp_adapter_gce_container command
# --pubsub_project_id=${data.google_project.project.project_id} \

resource "google_compute_instance" "mllp_adapter" {
  name         = "mllp-adapter"
  machine_type = "n2-standard-2"
  zone         = "northamerica-northeast1-a"
  # Force re-creation when GCE Container Metadata Value changes. See https://github.com/terraform-google-modules/terraform-google-container-vm/issues/29#issuecomment-1162639775 
  description = "GCE Container Metadata Value SHA512 hash (base64): ${base64sha512(module.mllp_adapter_gce_container.metadata_value)}"

  boot_disk {
    initialize_params {
      image = module.mllp_adapter_gce_container.source_image
    }
  }

  network_interface {
    subnetwork = var.northamerica_northeast1_subnetwork_name
    network_ip = google_compute_address.mllp_adapter.address
  }

  tags = [
    "allow-ingress-from-northamerica-northeast1-subnetwork"
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

resource "google_compute_instance" "mllp_adapter_test" {
  name         = "mllp-adapter-test"
  machine_type = "e2-standard-2"
  zone         = "northamerica-northeast1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = var.northamerica_northeast1_subnetwork_name
  }

  shielded_instance_config {
    enable_secure_boot = true
  }

  metadata = {
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
    block-project-ssh-keys    = true
    enable-oslogin            = true
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