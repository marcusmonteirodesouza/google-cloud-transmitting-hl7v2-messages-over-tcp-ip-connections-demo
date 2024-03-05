terraform {
  backend "gcs" {
    bucket = "vaguely-locally-robust-rat"
    prefix = "bootstrap"
  }
}
