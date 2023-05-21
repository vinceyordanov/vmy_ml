# -- Run this whenever initializing the terraform configuration for the first time -- #

# gcloud storage buckets create gs://r-server-326920-tf-states \
#     --project=r-server-326920 \
#     --default-storage-class=standard \
#     --location=europe-west4

  gcloud storage buckets update gs://r-server-326920-tf-states \
    --versioning \
    --lifecycle-file="./tf-state-bucket-lifecycle.json"