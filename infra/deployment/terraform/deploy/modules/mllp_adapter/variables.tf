variable "northamerica_northeast1_subnetwork_name" {
  type        = string
  description = "Subnetwork to attach the MLLP Adapter VM to, located in the northamerica-northeast1 region."
}

variable "hl7_v2_dataset_id" {
  type        = string
  description = "MLLP Adapter HL7v2 dataset ID."
}

variable "hl7_v2_dataset_name" {
  type        = string
  description = "MLLP Adapter HL7v2 dataset name."
}

variable "hl7_v2_store_id" {
  type        = string
  description = "MLLP Adapter HL7v2 store ID."
}

variable "hl7_v2_store_name" {
  type        = string
  description = "MLLP Adapter HL7v2 store name."
}

variable "my_vpn_northamerica_northeast1_ip_address" {
  type        = string
  description = "My VPN IP Address, reserved in the northamerica-northeast1 region."
}

variable "vpc_vpn_northamerica_northeast1_my_vpn_shared_secret_secret_data" {
  type        = string
  description = "Shared secret data used to set the secure session between the Cloud VPN gateway and my VPN gateway."
  sensitive   = true
}