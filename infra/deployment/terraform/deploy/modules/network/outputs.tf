output "vpc" {
  value = google_compute_network.vpc.name
}

output "vpc_northamerica_northeast1_subnetwork" {
  value = google_compute_subnetwork.vpc_northamerica_northeast1.name
}