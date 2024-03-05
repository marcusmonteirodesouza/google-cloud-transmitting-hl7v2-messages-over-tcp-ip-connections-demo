resource "google_compute_firewall" "vpc_allow_ingress_from_iap" {
  # https://cloud.google.com/iap/docs/using-tcp-forwarding#create-firewall-rule
  name      = "allow-ingress-from-iap"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports = [
      "22",
      "3389"
    ]
  }

  source_ranges = [
    "35.235.240.0/20"
  ]
}

resource "google_compute_firewall" "vpc_allow_ingress_from_northamerica_northeast1_subnetwork" {
  # https://cloud.google.com/iap/docs/using-tcp-forwarding#create-firewall-rule
  name      = "allow-ingress-from-northamerica-northeast1-subnetwork"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"

  allow {
    protocol = "all"
  }

  source_ranges = [
    google_compute_subnetwork.vpc_northamerica_northeast1.ip_cidr_range
  ]

  target_tags = [
    "allow-ingress-from-northamerica-northeast1-subnetwork"
  ]
}

resource "google_compute_firewall" "vpc_allow_ingress_my_vpn" {
  name      = "allow-ingress-outline-vpn-server"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"

  allow {
    protocol = "UDP"
    ports = [
      "500",
      "4500"
    ]
  }

  source_ranges = [
    "0.0.0.0/0"
  ]

  target_tags = [
    "allow-ingress-my-vpn"
  ]
}