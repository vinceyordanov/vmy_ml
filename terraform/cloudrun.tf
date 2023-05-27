# ----- Artifact registry to which docker containers will be deployed ----- #

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


# ----- Define properly formatted variable names to be used as image address ----- #

locals {
  artifact_storage_address = "europe-west4-docker.pkg.dev/r-server-326920/deploy-ml-model/model"
  #tag                      = "2.0.0"
}

# ----- Custom action used to call docker build on updates of tf configuration. ----- # 

# resource "null_resource" "docker_build" {

#     triggers = {
#         always_run  = timestamp()
#     }

#     provisioner "local-exec" {
#         working_dir = path.module
#         command     = "docker build -t ${local.artifact_storage_address}:3.0.0 . && docker push ${local.artifact_storage_address}:3.0.0"
#     }
# }



# ----- Create GCP cloud run service on which to deploy our containerized ML model & API ----- # 

resource "google_cloud_run_service" "default" {
    name     = "containerized-model-r"
    location = var.region
    project  = var.project_id

    metadata {
      annotations = {
        "run.googleapis.com/client-name" = "terraform"
      }
    }

    template {
      spec {
        containers {
          image = "${local.artifact_storage_address}:3.0.0"
          # command = [ "Rscript", "./backend.R" ]
          ports {
            container_port = 8080
          }
        }
      }
    }

    traffic {
    percent         = 100
    latest_revision = true
  }
 }



# ----- Cloud run invoker ----- # 

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

