#!/bin/bash

################mount point check################
mountpoint="/mnt/svn"
read -t1 < <(stat -t "$mountpoint" 2>&-)

if [ -z "$REPLY" ] ; then
echo "NFS mount stale. Removing..."
  echo -e "Ezbotsvn nfs is stopped.Please cheack asap`date`" | mail -s "EZBOTSVN NFS is stopped" john@abc.com
 exit;
fi

date=`date '+%d_%m_%Y_%H.%M'`
sed -e "s/{{date}}/$date/g" /root/path.txt > /root/path1.txt
pass=" $(cat /usr/.svn.cred)"
input="/root/path1.txt"
while IFS=, read -r link src dest file revision reporevision
do
svn info -r HEAD --username backupuser --password $pass "$link" |grep Revision | awk '{print $2}' >  $reporevision
svnrdump dump --username backupuser --password $pass $link  > $src/$file 2> $revision
done < $"$input"
input="/root/path1.txt"
while IFS=, read -r link src dest file revision reporevision
do
g="$(cat "$reporevision" | awk '{print $1}')"
echo -e ""$g""
x="$(cat "$revision" | tail -n 1  | awk '{print $4}' | sed 's/.$//')"
echo -e ""$x""
if [ "$x" -ge "$g"  ] ; then
echo "hi"
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
find  $src -mmin +2160 -type f | grep tgz > temp.txt
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

find /root/shellscriptlogs/svnlogs/ -mmin +10080 -type f | grep txt > temp.txt
for i in `cat temp.txt`
do
rm -rf $i
done
rm -f temp.txt

else
echo -e "Repo revsion is not equal in "$link" with revision ""$g"".Please cheack ASAP `date`" | mail -s "Repo Revision is not equal" -r "backup@abc.com" john@abc.com
fi
done < $"$input"
echo "" | mailx -S smtp=10.11.0.228 -r backup@abc.com  -s "$(echo -e "EZBot SVN Backup "$ip"\nX-Priority: 1")" john@abc.com < /root/filevalidate.txt
rm -rf /root/filevalidate.txt
rm -rf /root/path1.txt


#file content of /root/path.txt
https://10.11.0.235:8443/svn/AI/,/root/repobk/ai/,/mnt/svn/ai/,ai_{{date}}.dump,/tmp/ai.txt,/tmp/rev.txt
https://10.11.0.235:8443/svn/ATI/,/root/repobk/ati/,/mnt/ezbotsvn/ati/,ati_{{date}}.dump,/tmp/ati.txt,/tmp/atirev.txt
