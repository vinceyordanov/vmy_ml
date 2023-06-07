# -- Define the necessary variables to be used for creating Pub/Sub and BQ resources -- ##

variable "project_id" {
  description = "Project ID"
  type        = string
}

variable "region" {
  description = "Default region for GCP resources"
  type        = string
}

variable "zone" {
  description = "Zone of the GCP project"
  type        = string
}

variable "service_account" {
  description = "Service account to impersonate"
  type        = string
}


variable "artifact_repository_name" {
  description = "Name of Cloud Artifacts Registry"
  type        = string
}

variable "scheduler_sa_roles" {
  description = "List of roles for Cloud Scheduler job SA"
  type        = list(string)
}