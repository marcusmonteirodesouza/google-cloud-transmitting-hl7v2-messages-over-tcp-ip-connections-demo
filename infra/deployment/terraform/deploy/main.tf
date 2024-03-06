data "google_client_config" "default" {
}

provider "google" {
  project               = var.project_id
  region                = "northamerica-northeast1"
  user_project_override = true
}

provider "google-beta" {
  project               = var.project_id
  region                = "northamerica-northeast1"
  user_project_override = true
}

provider "docker" {
  registry_auth {
    address  = "northamerica-northeast1-docker.pkg.dev"
    username = "oauth2accesstoken"
    password = data.google_client_config.default.access_token
  }
}

module "iam" {
  source = "./modules/iam"
}

module "network" {
  source = "./modules/network"
}

module "healthcare" {
  source = "./modules/healthcare"
}

module "my_vpn" {
  source = "./modules/my_vpn"

  subnetwork_northamerica_northeast1_name = module.network.vpc_subnetwork_northamerica_northeast1_10_162_0_name
}

module "mllp_adapter" {
  source = "./modules/mllp_adapter"

  subnetwork_northamerica_northeast1_name = module.network.vpc_subnetwork_northamerica_northeast1_10_162_0_name
  hl7_v2_dataset_id                       = module.healthcare.transmitting_hl7v2_messages_over_tcp_ip_connections_dataset_id
  hl7_v2_dataset_name                     = module.healthcare.transmitting_hl7v2_messages_over_tcp_ip_connections_dataset_name
  hl7_v2_store_id                         = module.healthcare.transmitting_hl7v2_messages_over_tcp_ip_connections_store_id
  hl7_v2_store_name                       = module.healthcare.transmitting_hl7v2_messages_over_tcp_ip_connections_store_name
}

module "api" {
  source = "./modules/api"

  hl7v2_dataset_name = module.healthcare.transmitting_hl7v2_messages_over_tcp_ip_connections_dataset_name
  hl7v2_store_id     = module.healthcare.transmitting_hl7v2_messages_over_tcp_ip_connections_store_id
  hl7v2_store_name   = module.healthcare.transmitting_hl7v2_messages_over_tcp_ip_connections_store_name
}