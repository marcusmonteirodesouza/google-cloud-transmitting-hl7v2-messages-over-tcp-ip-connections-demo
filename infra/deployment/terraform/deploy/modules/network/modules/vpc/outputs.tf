output "name" {
  value = google_compute_network.vpc.name
}

output "subnetwork_northamerica_northeast1_10_162_0_name" {
  value = google_compute_subnetwork.northamerica_northeast1_10_162_0.name
}

output "subnetwork_northamerica_northeast1_10_162_0_ip_cidr_range" {
  value = google_compute_subnetwork.northamerica_northeast1_10_162_0.ip_cidr_range
}