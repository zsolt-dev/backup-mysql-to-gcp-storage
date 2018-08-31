#!/bin/sh

# Updates etc at: https://github.com/zsolt-dev/backup-mysql-to-gcp-storage/
# MIT license

# change these variables to what you need
MYSQLROOT=root
MYSQLPASS=YOUR_MYSQL_PW
GSBUCKET=YOUR_BUCKET_NAME
FILENAME=sqlBackup
DATABASE='--all-databases'
# the following line prefixes the backups with the defined directory. it must be blank or end with a /
GSPATH=
# when running via cron, the PATHs MIGHT be different. If you have a custom/manual MYSQL install, you should set this manually like MYSQLDUMPPATH=/usr/local/mysql/bin/
MYSQLDUMPPATH=/usr/bin/
# Change this if your gsutil is installed somewhere different.
# whereis mysqldump
GSUTILPATH=/usr/bin/
#tmp path.
TMP_PATH=/tmp/

DATESTAMP=$(date +"-%Y-%m-%d_%Hh%Mm")
echo "Starting backing up the database to a file..."

# dump all databases
${MYSQLDUMPPATH}mysqldump --quick --user=${MYSQLROOT} --password=${MYSQLPASS} ${DATABASE} > ${TMP_PATH}${FILENAME}.sql

echo "Done backing up the database to a file."
echo "Starting compression..."

tar czf ${TMP_PATH}${FILENAME}${DATESTAMP}.tar.gz ${TMP_PATH}${FILENAME}.sql

echo "Done compressing the backup file."

# uploading to GCP Storage bucket
echo "Uploading the new backup..."
${GSUTILPATH}gsutil cp ${TMP_PATH}${FILENAME}${DATESTAMP}.tar.gz gs://${GSBUCKET}/${GSPATH}/
echo "New backup uploaded."

echo "Removing the cache files..."
# remove databases dump
rm ${TMP_PATH}${FILENAME}.sql
rm ${TMP_PATH}${FILENAME}${DATESTAMP}.tar.gz
echo "Files removed."
echo "All done."