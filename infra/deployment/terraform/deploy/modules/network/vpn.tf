resource "google_compute_address" "vpc_vpn_northamerica_northeast1" {
  name   = "vpc-vpn-na-ne1-ip"
  region = "northamerica-northeast1"
}

resource "google_compute_vpn_gateway" "vpc_northamerica_northeast1" {
  name    = "vpc-vpn-na-ne1"
  region  = "northamerica-northeast1"
  network = google_compute_network.vpc.id
}

resource "google_compute_forwarding_rule" "vpc_vpn_northamerica_northeast1_rule_esp" {
  name        = "vpn-na-ne1-rule-esp"
  region      = "northamerica-northeast1"
  ip_address  = google_compute_address.vpc_vpn_northamerica_northeast1.address
  ip_protocol = "ESP"
  target      = google_compute_vpn_gateway.vpc_northamerica_northeast1.id
}

resource "google_compute_forwarding_rule" "vpc_vpn_northamerica_northeast1_rule_udp500" {
  name        = "vpn-na-ne1-rule-udp500"
  region      = "northamerica-northeast1"
  ip_address  = google_compute_address.vpc_vpn_northamerica_northeast1.address
  ip_protocol = "UDP"
  port_range  = "500"
  target      = google_compute_vpn_gateway.vpc_northamerica_northeast1.id
}

resource "google_compute_forwarding_rule" "vpc_vpn_northamerica_northeast1_rule_udp4500" {
  name        = "vpn-na-ne1-rule-udp4500"
  region      = "northamerica-northeast1"
  ip_address  = google_compute_address.vpc_vpn_northamerica_northeast1.address
  ip_protocol = "UDP"
  port_range  = "4500"
  target      = google_compute_vpn_gateway.vpc_northamerica_northeast1.id
}

resource "random_password" "vpc_vpn_northamerica_northeast1_my_vpn_gateway_shared_secret" {
  length = 32
}

resource "google_secret_manager_secret" "vpc_vpn_northamerica_northeast1_my_vpn_gateway_shared_secret" {
  secret_id = "vpc-vpn-na-ne1-my-vpn-gateway-shared-secret"

  replication {
    user_managed {
      replicas {
        location = "northamerica-northeast1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "vpc_vpn_northamerica_northeast1_vpn_tunnel_1_shared_secret" {
  secret      = google_secret_manager_secret.vpc_vpn_northamerica_northeast1_my_vpn_gateway_shared_secret.id
  secret_data = random_password.vpc_vpn_northamerica_northeast1_my_vpn_gateway_shared_secret.result
}

resource "google_compute_vpn_tunnel" "vpc_vpn_northamerica_northeast1_vpn_tunnel_1" {
  name          = "vpc-vpn-na-ne1-tunnel-1"
  region        = "northamerica-northeast1"
  peer_ip       = var.my_vpn_gateway_ip_address
  shared_secret = random_password.vpc_vpn_northamerica_northeast1_my_vpn_gateway_shared_secret.result
  ike_version   = 2
  local_traffic_selector = [
    "0.0.0.0/0"
  ]
  remote_traffic_selector = [
    "0.0.0.0/0"
  ]
  target_vpn_gateway = google_compute_vpn_gateway.vpc_northamerica_northeast1.id

  depends_on = [
    google_compute_forwarding_rule.vpc_vpn_northamerica_northeast1_rule_esp,
    google_compute_forwarding_rule.vpc_vpn_northamerica_northeast1_rule_udp500,
    google_compute_forwarding_rule.vpc_vpn_northamerica_northeast1_rule_udp4500,
  ]
}

resource "google_compute_route" "vpc_vpn_northamerica_northeast1_vpn_tunnel_1_route_1" {
  name                = "vpc-vpn-na-ne1-tunnel-1-route-1"
  network             = google_compute_network.vpc.name
  next_hop_vpn_tunnel = google_compute_vpn_tunnel.vpc_vpn_northamerica_northeast1_vpn_tunnel_1.id
  dest_range          = "0.0.0.0/0"
}
