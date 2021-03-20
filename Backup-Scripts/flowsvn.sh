#!/bin/bash
systemctl restart nfs
################mount point check################
#mountpoint="/mnt/svn-backup"
#read -t1 < <(stat -t "$mountpoint" 2>&-)
#if [ -z "$REPLY" ] ; then
#echo "NFS mount stale. Removing..."
#echo -e "EZFlowsvn nfs is stopped.Please cheack asap`date`" | mail -s "EZFlowSVN NFS is stopped" -r "backup@abc.com" jon@abc.com
#exit;
#[ -w /mnt/svn-backup/svn.sh ] && echo "writeable" > /dev/null || echo Denied > /dev/null
#if [ Denied ]
#then
 # umount -f -l /mnt/svn-backup > /dev/null 2>&1
 #mount -a
#fi

#fi
####################Mount point check#####
[ -w /mnt/svn-backup/svn.sh ] && echo "writeable" > /dev/null || echo Denied > /dev/null
if [ Denied ]
then
  umount -f -l /mnt/svn-backup > /dev/null 2>&1
 mount -a
fi
##########################################
date=`date '+%d_%m_%Y_%H.%M'`
sed -e "s/{{date}}/$date/g" /root/path.txt > /root/path1.txt
pass=" $(cat /usr/.svn.cred)"
input="/root/path1.txt"
while IFS=, read -r link link1 src dest file revision reporevision
do
svn info -r HEAD --username kmandava --password $pass "$link1" |grep Revision | awk '{print $2}' >  $reporevision
svnadmin dump  $link  > $src/$file 2> $revision
done < $"$input"
input="/root/path1.txt"
while IFS=, read -r link link1 src dest file revision reporevision
do
g="$(cat "$reporevision" | awk '{print $1}')"
echo -e ""$g""
x="$(cat "$revision" | tail -n 1  | awk '{print $4}' | sed 's/.$//')"
echo -e ""$x""
if [ "$x" -ge "$g"  ] ; then
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
echo -e " File valadation of ""$a"" and ""$b"" are equal with revision ""$x"""  >> /root/filevalidate.txt
else
echo "not equal"
echo -e " File valadation of ""$a"" and ""$b"" are not equal with revision ""$x"""  >> /root/filevalidate.txt
fi
find  $src -mmin +1440 -type f | grep tgz > temp.txt
for i in `cat temp.txt`
do
rm -rf $i
done
rm -f temp.txt
find  $dest -mmin +5040 -type f | grep tgz > temp.txt
for i in `cat temp.txt`
do
rm -rf $i
done
rm -f temp.txt
else
echo -e "Repo revsion is not equal in "$link" with revision ""$g"".Please cheack `date`" | mail -s "Repo Revision is not equal" -r "backup@abc.com" jon@abc.com
fi
done < $"$input"
cp /svn/authz /mnt/svn-backup/authz_$date
cp /etc/svn/svn-auth /mnt/svn-backup/svn-auth_$date
find  /mnt/svn-backup/ -mmin +5040 -type f | grep auth > temp.txt
for i in `cat temp.txt`
do
rm -rf $i
done

find /root/shellscriptlogs/ezflowsvnlogs -mmin +10080 -type f | grep txt > temp.txt
for i in `cat temp.txt`
do
rm -rf $i
done
rm -f temp.txt

rm -f temp.txt
echo "" | mailx -S smtp=10.11.0.228 -r backup@abc.com  -s "$(echo -e "EZFlow SVN Backup")" jon@abc < /root/filevalidate.txt
rm -rf /root/filevalidate.txt
rm -rf /root/path1.txt

#file content of /root/path.txt
/svn/repo1,http://10.11.0.47/svn/repo1,/repo1backup,/mnt/svn-backup/repo1,repo1_{{date}}.dump,/tmp/repo1.txt,/tmp/repo1rev.txt
/svn/tal,http://10.11.0.47/svn/tal,/talbackup,/mnt/svn-backup/tal,tal_{{date}}.dump,/tmp/tal.txt,/tmp/rev.txt

