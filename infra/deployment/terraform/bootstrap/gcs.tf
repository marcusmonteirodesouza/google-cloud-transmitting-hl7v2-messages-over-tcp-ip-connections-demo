resource "random_pet" "tfstate_bucket" {
  length = 4
}

resource "google_storage_bucket" "tfstate" {
  name     = random_pet.tfstate_bucket.id
  location = "northamerica-northeast1"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  depends_on = [
    module.enable_apis
  ]
}