#!/bin/bash

DB_USER="PyScada-user"
DB_PASS="PyScada-user-password"
DB_NAME="PyScada_db"

# DON'T FORGET ADAPT PATH
BACKUP_DIR="/media/pyscada-db-drive/databases-saves/PyScada_db"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

mysqldump --user=$DB_USER --password=$DB_PASS $DB_NAME > $BACKUP_DIR/$DB_NAME-$DATE.sql

gzip $BACKUP_DIR/$DB_NAME-$DATE.sql

find $BACKUP_DIR -type f -name ".gz" -mtime +30 -delete 
