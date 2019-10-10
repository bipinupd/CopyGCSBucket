import config
import json
from google.cloud import storage

def copy_blob(bucket_name, blob_name, new_bucket_name, new_blob_name):
    """Copies a blob from one bucket to another with a new name."""
    storage_client = storage.Client()
    source_bucket = storage_client.get_bucket(bucket_name)
    source_blob = source_bucket.blob(blob_name)
    destination_bucket = storage_client.get_bucket(new_bucket_name)

    new_blob = source_bucket.copy_blob(
        source_blob, destination_bucket, new_blob_name)

    print('Blob {} in bucket {} copied to blob {} in bucket {}.'.format(
        source_blob.name, source_bucket.name, new_blob.name,
        destination_bucket.name))

def copy_gcs_object(event, context):
    import base64
    source_bucket_name = config.SOURCE_BUCKET_NAME
    destinations = config.DESTINATION_BUCKET.split(",")
    print("""This Function was triggered by messageId {} published at {}
    """.format(context.event_id, context.timestamp))
    if 'data' in event:
        payload = json.loads(base64.b64decode(event['data']).decode('utf-8'))
        blob_name = payload['name']
    for destination_bucket_name in destinations:
        copy_blob(source_bucket_name, blob_name, destination_bucket_name, blob_name)