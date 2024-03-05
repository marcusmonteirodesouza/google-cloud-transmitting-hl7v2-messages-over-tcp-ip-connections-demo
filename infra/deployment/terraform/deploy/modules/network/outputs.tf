output "vpc" {
  value = google_compute_network.vpc.name
}

output "vpc_northamerica_northeast1_subnetwork" {
  value = google_compute_subnetwork.vpc_northamerica_northeast1.name
}

output "my_vpn_northamerica_northeast1_ip_address" {
  value = google_compute_address.my_vpn_northamerica_northeast1.address
}

output "vpc_vpn_northamerica_northeast1_my_vpn_shared_secret_secret_data" {
  value = google_secret_manager_secret_version.vpc_vpn_northamerica_northeast1_vpn_tunnel_1_shared_secret.secret_data
}