terraform {
  required_providers {
    google = {
      version = "5.19.0"
      source  = "hashicorp/google"
    }
    google-beta = {
      version = "5.19.0"
      source  = "hashicorp/google-beta"
    }
  }
}
