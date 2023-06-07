# ----- Artifact registry to which docker containers will be deployed ----- #

resource "google_artifact_registry_repository" "main" {
  project       = var.project_id
  location      = var.region
  repository_id = var.artifact_repository_name
  description   = "Repository for Cloud Run images"
  format        = "DOCKER"
  
  lifecycle {
    prevent_destroy = false
  }
}


# ----- Define properly formatted variable names to be used as image address ----- #

locals {
  artifact_storage_address = "europe-west4-docker.pkg.dev/r-server-326920/deploy-ml-model/model"
  tag                      = "5.0.0"
}


# -- Create an instance of the file we're monitoring for changes to trigger docker build -- # 

resource "local_file" "model_version" {
  content = templatefile("${path.module}/../src/changelog.txt", {})
  filename = "${path.module}/../src/changelog.txt"
}


# ----- Custom action used to call docker build on updates of tf configuration. ----- # 

resource "null_resource" "docker_build" {
    triggers = {
        file_changed = md5(local_file.model_version.content)
    }
    provisioner "local-exec" {
        working_dir = path.module
        command     = "cd ../src && docker build -t ${local.artifact_storage_address}:${local.tag} . && docker push ${local.artifact_storage_address}:${local.tag}"
    }
    depends_on = [local_file.model_version]
}



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
          image = "${local.artifact_storage_address}:${local.tag}"
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
    depends_on = [
        null_resource.docker_build
    ]
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

