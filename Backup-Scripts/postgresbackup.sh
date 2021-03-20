#!/bin/bash

################mount point check################
mountpoint="/mnt/20dbbackup"
read -t1 < <(stat -t "$mountpoint" 2>&-)

if [ -z "$REPLY" ] ; then
echo "NFS mount stale. Removing..."
  echo -e "Ezbotsvn nfs is stopped.Please cheack asap`date`" | mail -s "EZBOTSVN NFS is stopped" -r "backup@abc.com" jon@abc.com
 exit;
fi

date=`date '+%d_%m_%Y_%H.%M'`
sed -e "s/{{date}}/$date/g" /root/20path.txt > /root/20path1.txt
pass="$(cat /usr/.db20.cred)"
input="/root/20path1.txt"
while IFS=, read -r ip dbname src dest file
do
PGPASSWORD=$pass /usr/pgsql-9.6/bin/pg_dump -U backupuser -h $ip -p 5432 $dbname > $src/$file

cd $src
tar cvfz $file.tgz $file;
cp $src/$file.tgz $dest;
rm -rf $src/$file;

a="$(cd $src ; ls -t | head -n1)"
b="$(cd $dest ; ls -t | head -n1)"
c=$(cd $src ; md5sum  $a | awk '{print $1}')
d=$(cd $dest ; md5sum  $b | awk '{print $1}')
if [ "$c" = "$d" ] ; then
echo "they are equal"

echo -e " File valadation of database ""$dbname"" are equal ""$a"" and ""$b"" "  >> /root/20filevalidate.txt
else
echo "not equal"
echo -e " File valadation of database ""$dbname"" are not equal ""$a"" and ""$b"" "  >> /root/20filevalidate.txt
echo "File validation of ""$dbname"" are not eqaul.Please check ASAP." | mailx -S smtp=10.11.0.228 -r backup@abc.com  -s "$(echo -e "2.0 DataBase Backup file validation are not equal")" jon@abc.com
fi


find  $src -mmin +5840 -type f | grep tgz > temp.txt
for i in `cat temp.txt`
do
rm -rf $i
done
rm -f temp.txt
find  $dest -mmin +5840 -type f | grep tgz > temp.txt
for i in `cat temp.txt`
do
rm -rf $i
done
rm -f temp.txt

find /root/shellscriptlogs/20dblogs/ -mmin +10080 -type f | grep txt > temp.txt
for i in `cat temp.txt`
do
rm -rf $i
done
rm -f temp.txt

done < $"$input"
echo "" | mailx -S smtp=10.11.0.228 -r backup@abc.com  -s "$(echo -e "2.0 DataBase Backup")" jon@abc.com < /root/20filevalidate.txt
rm -rf /root/20path1.txt
rm -rf /root/20filevalidate.txt

#file content of /root/20filevalidate
10.11.0.113,PIDevDB,/root/20dbbackup/PIDevDB/,/mnt/20dbbackup/PIDevDB/,PIDevDB_{{date}}.dump
10.11.0.113,dev,/root/20dbbackup/dev/,/mnt/20dbbackup/dev/,dev_{{date}}.dump
