// Settings for the google cloud account
// Write the path to the json key giving access to the project
provider "google" {
  credentials = file("tf/roi-takeoff-user72-f77e2019b057.json")
  project = "roi-takeoff-user72"
  region  = "europe-central2"
  zone    = "europe-central2"
}

// Resource 1: cloud run service running the docker image
// Write the path to the docker image hosted in the google container registry
// To set up this resource with Terraform, the service account key used
// must have the appropriate permissions.
resource "google_cloud_run_service" "default" {
  name     = "demo"
  location = "europe-central2"

  template {
    spec {
      containers {
        image = "gcr.io/roi-takeoff-user72/level1v2"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

//Resource 2: create datastore index
resource "google_datastore_index" "default" {
  kind = "Pet"
  properties {
    name = "added"
    direction = "ASCENDING"
  }
  properties {
    name = "caption"
    direction = "ASCENDING"
  }
  properties {
      name = "email"
      direction = "ASCENDING"
  }
  properties {
      name = "image"
      direction = "ASCENDING"
  }
  properties {
      name = "likes"
      direction = "ASCENDING"
  }
  properties {
      name = "owner"
      direction = "ASCENDING"
  }
  properties {
        name = "petname"
        direction = "ASCENDING"
  }
}
