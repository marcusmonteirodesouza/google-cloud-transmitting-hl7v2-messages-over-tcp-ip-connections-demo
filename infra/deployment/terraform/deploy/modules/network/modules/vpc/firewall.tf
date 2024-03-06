resource "google_compute_firewall" "allow_ingress_from_iap" {
  # https://cloud.google.com/iap/docs/using-tcp-forwarding#create-firewall-rule
  name      = "${google_compute_network.vpc.name}-allow-ingress-from-iap"
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

resource "google_compute_firewall" "allow_ingress_vpn_server" {
  name      = "${google_compute_network.vpc.name}-allow-ingress-vpn-server"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"

  allow {
    protocol = "ESP"
  }

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
    "allow-ingress-vpn-server"
  ]
}

resource "google_compute_firewall" "allow_ingress_mllp" {
  name      = "${google_compute_network.vpc.name}-allow-ingress-mllp"
  network   = google_compute_network.vpc.name
  direction = "INGRESS"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports = [
      "2575"
    ]
  }

  source_ranges = [
    google_compute_subnetwork.northamerica_northeast1_10_162_0.ip_cidr_range
  ]

  target_tags = [
    "allow-ingress-mllp"
  ]
}