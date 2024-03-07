resource "google_compute_subnetwork" "northamerica_northeast1_10_162_0" {
  name          = "${google_compute_network.vpc.name}-subnet-na-ne1-10-162-0"
  ip_cidr_range = "10.162.0.0/20"
  region        = "northamerica-northeast1"
  network       = google_compute_network.vpc.id
}

resource "google_compute_router" "northamerica_northeast1_1" {
  name    = "${google_compute_network.vpc.name}-na-ne1-router-1"
  network = google_compute_network.vpc.name
  region  = "northamerica-northeast1"
}

resource "google_compute_address" "northamerica_northeast1_router_1" {
  name   = "${google_compute_router.northamerica_northeast1_1.name}-ip-addr"
  region = "northamerica-northeast1"
}

resource "google_compute_router_nat" "northamerica_northeast1_router_1" {
  name   = "${google_compute_router.northamerica_northeast1_1.name}-static-nat"
  router = google_compute_router.northamerica_northeast1_1.name
  region = "northamerica-northeast1"

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [google_compute_address.northamerica_northeast1_router_1.self_link]

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.northamerica_northeast1_10_162_0.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}