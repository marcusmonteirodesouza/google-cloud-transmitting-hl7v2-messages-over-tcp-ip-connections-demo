variable "subnetwork_northamerica_northeast1_name" {
  type        = string
  description = "Name of the subnetwork, located in northamerica-northeast1, to which the MLLP VM will be attached to."
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