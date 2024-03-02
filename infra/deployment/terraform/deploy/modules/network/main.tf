resource "google_compute_network" "vpc" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "vpc_northamerica_northeast1" {
  name          = "subnet-na-ne1-10-162-0"
  ip_cidr_range = "10.162.0.0/20"
  region        = "northamerica-northeast1"
  network       = google_compute_network.vpc.id
}