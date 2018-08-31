# Cron for creating MySQL backups and storing them to the Google Cloud Platform Storage

This SH script is just creating backups to GCP Object Storage. 

It is a good practice that the backup script does not have access to edit or delete the backups. This script should be combined with Google Cloud Function that will handle the backup deletion: https://github.com/zsolt-dev/auto-delete-gcp-storage-backups/

Please give this script a **Star** to let everyone know that you are doing backups *The Right Way™* 

## How to install?
1. Create a Google Cloud Platform account, if you do not have one already
2. Install gsutil https://cloud.google.com/storage/docs/gsutil_install#deb
3. Create a bucket in the Cloud Console. Use the Nearline or Cold storage, since backups will not be read except for backup retrieval.
4. Create a service account that **will only have a write access** to your backup bucket. Service account is a limited account for scripts. IAM & admin > Service accounts
5. Download your service account file
6. Setup gsutil with your service account file
```sh
gcloud auth activate-service-account --key-file /path/to/gcp-service-account-file.json
```
7. Download backupMysqlToGcpStorage.sh and store it somewhere, for example to /usr/local/bin/
8. Configure your MySQL username/password and bucket name in the backupMysqlToGcpStorage.sh file
9. Change file permissions to:
```sh
chmod 700 /usr/local/bin/backupMysqlToGcpStorage.sh
```
10. Now just setup the crontab
```sh
crontab -e
```

and add this line:
```sh
0 * * * * /usr/local/bin/backupMysqlToGcpStorage.sh
```

## Final notes
Thank you for choosing this script for your backup needs.

Please give this script a **Star**.