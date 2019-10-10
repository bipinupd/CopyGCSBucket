This is a solution to copy the content of a bucket to other buckets. 

Once the object landed to a bucket (event : `OBJECT_FINALIZE`), GCS automatically sends an event a pub/sub

```gsutil notification create -t [[topic_name]] -e OBJECT_FINALIZE -f json gs://[[source_bucket_name]]```

Cloud function `copy_gcs_object` copies objects in one bucket to other buckets. 

Please set the following variable in deploy.sh

```
#Source folder which content is to be copied
SOURCE_BUCKET_NAME=[[source_bucket_name]]
#Destination folder when content has to be copies
DESTINATION_BUCKET=[[destination_bucket_name]]
#project id where you run the cloud function
PROJECT_ID=[[project_id]]
#Service account name that runs the cloud function
SERVICE_ACCOUNT=[[service_Account_to_run_cloud_fuction]]
```

Once this is set run the `sh deploy.sh`. The user/agent invoking the `deploy.sh` script should have the required permission to deploy cloud functions and change iam policy for the source and destination buckets. 