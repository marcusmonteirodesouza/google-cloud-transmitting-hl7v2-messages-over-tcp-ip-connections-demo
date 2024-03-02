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