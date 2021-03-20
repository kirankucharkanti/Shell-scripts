#!/bin/bash

#to append date
date=`date '+%d_%m_%Y_%H.%M'`
function backup7(){

mysqldump -h 172.16.0.7 -u crm -pcrm  prfex > /prefex/perfex_$date.sql
cd /prefex;
tar cvfz perfex_$date.sql.tgz perfex_$date.sql;
cp /prefex/perfex_$date.sql.tgz /mnt/dbbackup/prefex;
rm -rf /prefex/prefex_$date.sql;
echo -e "Backup is Done"

#Delete last 15 days old backup from SVN server self location
cd /prefex
find  /prefex -mtime +15 -type f | grep tgz > temp.txt
for i in `cat temp.txt`
do
rm -rf $i
done

rm -f temp.txt

#Delete last 15 days old backup from remote NFS server location
cd /mnt/dbbackup/prefex
find  /mnt/dbbackup/prefex -mtime +15 -type f | grep tgz > temp1.txt
for i in `cat temp1.txt`
do
rm -rf $i
done

rm -f temp1.txt
};

MYSQL_USER=crm
MYSQL_PASS=crm
MYSQL_CONN="-u${MYSQL_USER} -p${MYSQL_PASS}"
mysqladmin -h 172.16.0.7 ping ${MYSQL_CONN} 2>/dev/null 1>/dev/null
MYSQLD_RUNNING=${?}
if [ ${MYSQLD_RUNNING} -eq 0 ]; then backup7;  fi
if [ ${MYSQLD_RUNNING} -eq 1 ]; then
echo "MYSQL perfex and orangehrms  is not working.Xampp is stopped or not working.Please cheack log ASAP `date`" | mailx -S smtp=10.11.0.228 -r backup@abc.com  -s "$(echo -e "MYSQL perfex and orangehrms stopped")" jon@abc.com ; break; fi
