project_id                              = "r-server-326920"
region                                  = "europe-west1"
zone                                    = "europe-west1"
service_account                         = "terraform@r-server-326920.iam.gserviceaccount.com"
artifact_repository_name                = "deploy-ml-model"
scheduler_sa_roles                      = ["roles/cloudscheduler.admin", "roles/run.invoker"]