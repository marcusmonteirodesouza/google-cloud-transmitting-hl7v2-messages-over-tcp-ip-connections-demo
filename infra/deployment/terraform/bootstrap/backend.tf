terraform {
  backend "gcs" {
    bucket = "rapidly-precisely-singular-foxhound"
    prefix = "bootstrap"
  }
}
