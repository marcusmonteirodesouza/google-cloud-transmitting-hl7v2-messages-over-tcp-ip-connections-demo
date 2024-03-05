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

module "network" {
  source = "./modules/network"
}

module "healthcare" {
  source = "./modules/healthcare"
}

module "mllp_adapter" {
  source = "./modules/mllp_adapter"

  northamerica_northeast1_subnetwork_name                          = module.network.vpc_northamerica_northeast1_subnetwork
  hl7_v2_dataset_id                                                = module.healthcare.transmitting_hl7v2_messages_over_tcp_ip_connections_dataset_id
  hl7_v2_dataset_name                                              = module.healthcare.transmitting_hl7v2_messages_over_tcp_ip_connections_dataset_name
  hl7_v2_store_id                                                  = module.healthcare.transmitting_hl7v2_messages_over_tcp_ip_connections_store_id
  hl7_v2_store_name                                                = module.healthcare.transmitting_hl7v2_messages_over_tcp_ip_connections_store_name
  my_vpn_northamerica_northeast1_ip_address                        = module.network.my_vpn_northamerica_northeast1_ip_address
  vpc_vpn_northamerica_northeast1_my_vpn_shared_secret_secret_data = module.network.vpc_vpn_northamerica_northeast1_my_vpn_shared_secret_secret_data
}

module "api" {
  source = "./modules/api"

  hl7v2_dataset_name = module.healthcare.transmitting_hl7v2_messages_over_tcp_ip_connections_dataset_name
  hl7v2_store_id     = module.healthcare.transmitting_hl7v2_messages_over_tcp_ip_connections_store_id
  hl7v2_store_name   = module.healthcare.transmitting_hl7v2_messages_over_tcp_ip_connections_store_name
}