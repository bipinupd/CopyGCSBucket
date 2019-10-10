#!/usr/bin/env bash
set -Eeuo pipefail

#Source folder which content is to be copied
SOURCE_BUCKET_NAME=[[source_bucket_name]]
#Destination folder when content has to be copies
DESTINATION_BUCKET=[[destination_bucket_name]]
#project id where you run the cloud function
PROJECT_ID=[[project_id]]
#Service account name that runs the cloud function
SERVICE_ACCOUNT=[[service_Account_to_run_cloud_fuction]]


echo "SOURCE_BUCKET_NAME='${SOURCE_BUCKET_NAME}'" > config.py
echo "DESTINATION_BUCKET='${DESTINATION_BUCKET}'" >> config.py


# Grant the service account the ability to read and write objects in storage
gsutil iam ch \
  "serviceAccount:${SERVICE_ACCOUNT}:legacyBucketReader" \
  "serviceAccount:${SERVICE_ACCOUNT}:objectViewer" \
  "gs://${SOURCE_BUCKET_NAME}"

for bucket in ${DESTINATION_BUCKET//,/ }
do
  gsutil iam ch \
  "serviceAccount:${SERVICE_ACCOUNT}:objectCreator" \
  "serviceAccount:${SERVICE_ACCOUNT}:legacyObjectOwner" \
  "gs://${bucket}"
done

gsutil notification create -t ${PROJECT_ID}_data_received_on_${SOURCE_BUCKET_NAME}_notification -e OBJECT_FINALIZE -f json gs://${SOURCE_BUCKET_NAME}

gcloud functions deploy copy_gcs_object --runtime python37 --trigger-topic ${PROJECT_ID}_data_received_on_${SOURCE_BUCKET_NAME}_notification

