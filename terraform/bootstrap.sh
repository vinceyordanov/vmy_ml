# -- Run this whenever initializing the terraform configuration for the first time -- #

storage_buckets=$(gcloud storage ls)

if [ -z "${storage_buckets}" ]

then 
  gcloud storage buckets create ${BUCKET_ID} \
    --project=${PROJECT_ID} \
    --default-storage-class=standard \
    --location=europe-west4

  gcloud storage buckets update ${BUCKET_ID} \
    --versioning \
    --lifecycle-file="./terraform/tf-state-bucket-lifecycle.json"


else
    echo "No need to create any storage buckets."
fi

