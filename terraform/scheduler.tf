# -- Enable Cloud Scheduler Service API -- # 
resource "google_project_service" "cloudscheduler_googleapis_com" {
  project = var.project_id
  service = "cloudscheduler.googleapis.com"
}

# -- Enable IAM Service API -- # 
resource "google_project_service" "iam_googleapis_com" {
  project = var.project_id
  service = "iam.googleapis.com"
}


# -- Create Cloud Scheduler Service Account to use for scheduling CRON HTTP requests to CloudRun -- # 
resource "google_service_account" "default" {
  depends_on   = [google_project_service.iam_googleapis_com]
  account_id   = "scheduler-sa"
  description  = "Cloud Scheduler service account; used to trigger scheduled Cloud Run jobs."
  display_name = "scheduler-sa"
}
  
# -- Grant Cloud Scheduler SA with necessary IAM permissions to crate scheduler jobs and invoke CloudRun -- # 
resource "google_project_iam_member" "runner" {
  for_each                     = toset(var.scheduler_sa_roles)
  project                      = var.project_id
  role                         = each.value
  member                       = "serviceAccount:scheduler-sa@r-server-326920.iam.gserviceaccount.com"
}

# -- Create cloud scheduler job -- #
resource "google_cloud_scheduler_job" "default" {
  name             = "scheduled-cloud-run-job-ml"
  description      = "Invokes the Cloud Run container with our ML model on a recurrent basis."
  schedule         = "*/10 * * * *"
  time_zone        = "Europe/Stockholm"
  retry_config {
    retry_count = 0
  }
  http_target {
    http_method = "GET"
    uri         = "${google_cloud_run_service.default.status[0].url}/predict?arg_1=5.4&arg_2=3.1&arg_3=1.2&arg_4=0.4"
    headers     = {"Content-Type" : "application/json", "User-Agent" : "Google-Cloud-Scheduler"}
    oidc_token {
      service_account_email = google_service_account.default.email
    }
  }
}