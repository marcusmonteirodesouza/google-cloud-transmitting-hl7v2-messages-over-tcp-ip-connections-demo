locals {
  vpc_northamerica_northeast1_my_vpn_gateway_prefix = "${google_compute_ha_vpn_gateway.vpc_northamerica_northeast1.name}-${google_compute_external_vpn_gateway.my_vpn_gateway.name}"
}

resource "google_compute_ha_vpn_gateway" "vpc_northamerica_northeast1" {
  region  = "northamerica-northeast1"
  name    = "ha-vpn-na-ne1"
  network = google_compute_network.vpc.id
}

resource "google_compute_external_vpn_gateway" "my_vpn_gateway" {
  name            = "my-vpn-gateway"
  redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
  description     = "My VPN gateway"
  interface {
    id         = 0
    ip_address = var.my_vpn_gateway_ip_address
  }
}

resource "google_compute_router" "vpc_ha_vpn_northamerica_northeast1_router1" {
  name    = "ha-vpn-na-ne1-router1"
  network = google_compute_network.vpc.name
  bgp {
    asn = 64514
  }
}

resource "random_password" "vpc_ha_vpn_northamerica_northeast1_my_vpn_gateway_shared_secret" {
  length = 32
}

resource "google_secret_manager_secret" "vpc_ha_vpn_northamerica_northeast1_my_vpn_gateway_shared_secret" {
  secret_id = "${local.vpc_northamerica_northeast1_my_vpn_gateway_prefix}-shared-secret"

  replication {
    user_managed {
      replicas {
        location = "northamerica-northeast1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "vpc_ha_vpn_northamerica_northeast1_vpn_tunnerl_shared_secret" {
  secret      = google_secret_manager_secret.vpc_ha_vpn_northamerica_northeast1_my_vpn_gateway_shared_secret.id
  secret_data = random_password.vpc_ha_vpn_northamerica_northeast1_my_vpn_gateway_shared_secret.result
}

resource "google_compute_vpn_tunnel" "vpc_ha_vpn_northamerica_northeast1_my_vpn_gateway_1" {
  name                            = "${local.vpc_northamerica_northeast1_my_vpn_gateway_prefix}-tunnel1"
  region                          = "northamerica-northeast1"
  vpn_gateway                     = google_compute_ha_vpn_gateway.vpc_northamerica_northeast1.id
  peer_external_gateway           = google_compute_external_vpn_gateway.my_vpn_gateway.id
  peer_external_gateway_interface = 0
  shared_secret                   = random_password.vpc_ha_vpn_northamerica_northeast1_my_vpn_gateway_shared_secret.result
  router                          = google_compute_router.vpc_ha_vpn_northamerica_northeast1_router1.id
  vpn_gateway_interface           = 0
}

resource "google_compute_vpn_tunnel" "vpc_ha_vpn_northamerica_northeast1_my_vpn_gateway_2" {
  name                            = "${local.vpc_northamerica_northeast1_my_vpn_gateway_prefix}-tunnel2"
  region                          = "northamerica-northeast1"
  vpn_gateway                     = google_compute_ha_vpn_gateway.vpc_northamerica_northeast1.id
  peer_external_gateway           = google_compute_external_vpn_gateway.my_vpn_gateway.id
  peer_external_gateway_interface = 0
  shared_secret                   = random_password.vpc_ha_vpn_northamerica_northeast1_my_vpn_gateway_shared_secret.result
  router                          = google_compute_router.vpc_ha_vpn_northamerica_northeast1_router1.id
  vpn_gateway_interface           = 1
}

resource "google_compute_router_interface" "vpc_ha_vpn_northamerica_northeast1_router1_interface1" {
  name       = "${local.vpc_northamerica_northeast1_my_vpn_gateway_prefix}-router1-interface1"
  router     = google_compute_router.vpc_ha_vpn_northamerica_northeast1_router1.name
  region     = "northamerica-northeast1"
  ip_range   = "169.254.0.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.vpc_ha_vpn_northamerica_northeast1_my_vpn_gateway_1.name
}

resource "google_compute_router_peer" "vpc_ha_vpn_northamerica_northeast1_router1_peer1" {
  name                      = "${local.vpc_northamerica_northeast1_my_vpn_gateway_prefix}-router1-peer1"
  router                    = google_compute_router.vpc_ha_vpn_northamerica_northeast1_router1.name
  region                    = "northamerica-northeast1"
  peer_ip_address           = "169.254.0.2"
  peer_asn                  = 64515
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.vpc_ha_vpn_northamerica_northeast1_router1_interface1.name
}

resource "google_compute_router_interface" "vpc_ha_vpn_northamerica_northeast1_router1_interface2" {
  name       = "${local.vpc_northamerica_northeast1_my_vpn_gateway_prefix}-router1-interface2"
  router     = google_compute_router.vpc_ha_vpn_northamerica_northeast1_router1.name
  region     = "northamerica-northeast1"
  ip_range   = "169.254.1.1/30"
  vpn_tunnel = google_compute_vpn_tunnel.vpc_ha_vpn_northamerica_northeast1_my_vpn_gateway_2.name
}

resource "google_compute_router_peer" "vpc_ha_vpn_northamerica_northeast1_router1_peer2" {
  name                      = "${local.vpc_northamerica_northeast1_my_vpn_gateway_prefix}-router1-peer2"
  router                    = google_compute_router.vpc_ha_vpn_northamerica_northeast1_router1.name
  region                    = "northamerica-northeast1"
  peer_ip_address           = "169.254.1.2"
  peer_asn                  = 64515
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.vpc_ha_vpn_northamerica_northeast1_router1_interface2.name
}
