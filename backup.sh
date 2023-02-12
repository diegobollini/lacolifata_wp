#!/bin/bash
## https://theme.fm/a-shell-script-for-a-complete-wordpress-backup/
## replace all {fields} with your credentials and paths

NOW=$(date +"%Y-%m-%d-%H%M")
FILE="lacolifata.$NOW.tar"
BACKUP_DIR="{path_to_save_backups}"
WWW_DIR="{path_of_the_dir_to_backup}"

DB_USER="{db_user_name}"
DB_PASS="{db_user_pass}"
DB_NAME="{db_name}"
DB_FILE="lacolifata.com.ar.$NOW.sql"

WWW_TRANSFORM='s,^{www_dir},www,'
DB_TRANSFORM='s,^{backup_dir},database,'

tar -cvf $BACKUP_DIR/$FILE --transform $WWW_TRANSFORM $WWW_DIR
mysqldump -u$DB_USER -p$DB_PASS $DB_NAME --no-tablespaces > $BACKUP_DIR/$DB_FILE

tar --append --file=$BACKUP_DIR/$FILE --transform $DB_TRANSFORM $BACKUP_DIR/$DB_FILE
rm $BACKUP_DIR/$DB_FILE
gzip -9 $BACKUP_DIR/$FILE

# delete all but 5 recent wordpress files back-ups (files having .tar.gz extension) in backup folder.

find $BACKUP_DIR -maxdepth 1 -name "\*.tar.gz" -type f | xargs -x ls -t | awk 'NR>5' | xargs -L1 rm