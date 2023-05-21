
resource "google_artifact_registry_repository" "main" {
  project       = var.project_id
  location      = var.region
  repository_id = var.artifact_repository_name
  description   = "Repository for Cloud Run images"
  format        = "DOCKER"
  
  lifecycle {
    prevent_destroy = true
  }
}


locals {
  artifact_repository_name = var.artifact_repository_name
  artifact_storage_address = "${var.region}-docker.pkg.dev/${var.project}/${local.artifact_repository_name}/model"
  image_tag                = "1.0.0"
  name                     = "${local.artifact_storage_address}:${local.image_tag}"
}

data "docker_registry_image" "main" {
  name = "${local.artifact_storage_address}:${local.image_tag}"
}


resource "null_resource" "docker_build" {

    triggers = {
        always_run  = timestamp()
    }

    provisioner "local-exec" {
        working_dir = path.module
        command     = "docker build -t ${local.name} . && docker push ${local.name}"
    }
}



resource "google_cloud_run_service" "default" {
    name     = "containerized_model"
    location = var.region

    metadata {
      annotations = {
        "run.googleapis.com/client-name" = "terraform"
      }
    }

    template {
      spec {
        containers {
          image = "${local.artifact_storage_address}@${data.docker_registry_image.main.sha256_digest}"
        }
      }
    }

    traffic {
    percent         = 100
    latest_revision = true
  }
 }


data "google_iam_policy" "noauth" {
   binding {
     role = "roles/run.invoker"
     members = ["allUsers"]
   }
 }

 resource "google_cloud_run_service_iam_policy" "noauth" {
   location    = google_cloud_run_service.default.location
   project     = google_cloud_run_service.default.project
   service     = google_cloud_run_service.default.name

   policy_data = data.google_iam_policy.noauth.policy_data
}

