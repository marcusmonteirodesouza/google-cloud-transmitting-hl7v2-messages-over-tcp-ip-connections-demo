locals {
  my_vpn_sa_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ]
}

resource "google_service_account" "my_vpn" {
  account_id   = "my-vpn-sa"
  display_name = "My VPN Gateway service account"
}

resource "google_project_iam_member" "my_vpn_sa" {
  for_each = toset(local.my_vpn_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.my_vpn.email}"
}

resource "google_compute_address" "my_vpn" {
  name   = "my-vpn-address"
  region = "northamerica-northeast1"
}

resource "random_password" "my_vpn_preshared_key" {
  length = 32
}

resource "google_secret_manager_secret" "my_vpn_preshared_key" {
  secret_id = "my-vpn-preshared-key"

  replication {
    user_managed {
      replicas {
        location = "northamerica-northeast1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "my_vpn_preshared_key" {
  secret      = google_secret_manager_secret.my_vpn_preshared_key.id
  secret_data = random_password.my_vpn_preshared_key.result
}

resource "random_password" "my_vpn_user_password" {
  length = 16
}

resource "google_secret_manager_secret" "my_vpn_user_password" {
  secret_id = "my-vpn-user-password"

  replication {
    user_managed {
      replicas {
        location = "northamerica-northeast1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "my_vpn_user_password" {
  secret      = google_secret_manager_secret.my_vpn_user_password.id
  secret_data = random_password.my_vpn_user_password.result
}

module "my_vpn_gce_container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 3.1"

  container = {
    image = "hwdsl2/ipsec-vpn-server"

    env = [
      {
        name  = "VPN_IPSEC_PSK",
        value = google_secret_manager_secret_version.my_vpn_preshared_key.secret_data
      },
      {
        name  = "VPN_USER"
        value = "vpnuser"
      },
      {
        name  = "VPN_PASSWORD"
        value = random_password.my_vpn_user_password.result
      },
      {
        name  = "VPN_PUBLIC_IP"
        value = google_compute_address.my_vpn.address
      }
    ]

    securityContext = {
      privileged : true
    }

    volumeMounts = [
      {
        mountPath = "/etc/ipsec.d"
        name      = "ikev2-vpn-data"
        readOnly  = false
      },
      {
        mountPath = "/lib/modules:ro"
        name      = "lib-modules"
        readOnly  = false
      },
    ]
  }

  volumes = [
    {
      name = "ikev2-vpn-data"
      hostPath = {
        path = "ikev2-vpn-data"
      }
    },
    {
      name = "lib-modules"
      hostPath = {
        path = "/lib/modules"
      }
    },
  ]

  restart_policy = "Always"
}

resource "google_compute_instance" "my_vpn" {
  # Force re-creation when GCE Container Metadata Value changes.
  name         = "my-vpn-${md5(module.my_vpn_gce_container.metadata_value)}"
  machine_type = "n2-standard-2"
  zone         = "northamerica-northeast1-a"

  boot_disk {
    initialize_params {
      image = module.my_vpn_gce_container.source_image
    }
  }

  network_interface {
    subnetwork = var.subnetwork_northamerica_northeast1_name
    access_config {
      nat_ip = google_compute_address.my_vpn.address
    }
  }

  can_ip_forward = true

  tags = [
    "allow-ingress-vpn-server"
  ]

  shielded_instance_config {
    enable_secure_boot = true
  }

  metadata = {
    gce-container-declaration = module.my_vpn_gce_container.metadata_value
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
    block-project-ssh-keys    = true
    enable-oslogin            = true
  }

  labels = {
    container-vm = module.my_vpn_gce_container.vm_container_label
  }

  allow_stopping_for_update = true

  service_account {
    email = google_service_account.my_vpn.email
    scopes = [
      "cloud-platform",
    ]
  }

  depends_on = [
    google_project_iam_member.my_vpn_sa,
  ]
}