#!/bin/bash
gitlab-rake gitlab:backup:create

cd /var/opt/gitlab/backups/
p= ls -Art | tail -n 1
echo -e ""$P""
cp -r /var/opt/gitlab/backups/$P /mnt/gitbackup/
echo -e "Backup is Done"

#Delete last 2 days old backup from SVN server self location
cd /var/opt/gitlab/backups/
find  /var/opt/gitlab/backups/ -mmin +1440 -type f | grep tar > /root/temp.txt
for i in `cat /root/temp.txt`
do
rm -rf $i
done

rm -f temp.txt


#Delete last 2 days old backup from remote NFS server location
cd /mnt/gitbackup/
find  /mnt/gitbackup/ -mmin +5040 -type f | grep tar > /root/temp1.txt
for i in `cat /root/temp1.txt`
do
rm -rf $i
done

rm -f temp1.txt

#Delete last 7days old logs
find /root/shellscriptlogs/gitlogs/ -mmin +10080 -type f | grep txt > temp.txt
for i in `cat temp.txt`
do
rm -rf $i
done
rm -f temp.txt

echo -e "GIT-LAB backup successfully completed and copied to EPSD-013 NFS location  on `date`" | mail -s "GIT-LAB backup backup" -r "backup@abc.com" jon@abc.com
