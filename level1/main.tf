// Settings for the google cloud account
// Write the path to the json key giving access to the project
provider "google" {
  credentials = file("tf/45ca3eec03e5.json")
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
# Set service public
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

//Resource 2: create noauth iam policy
resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.default.location
  project  = google_cloud_run_service.default.project
  service  = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
  depends_on  = [google_cloud_run_service.default]
}

//Resource 3: create datastore index
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
