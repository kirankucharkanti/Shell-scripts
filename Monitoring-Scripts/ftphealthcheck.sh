#!/bin/bash
file="/root/ftpip.txt"
while IFS= read -r line
do
pass=" $(cat /usr/.ftp.cred)"
wget --spider --tries=1 --ftp-user deployment --ftp-password $pass ftp://$line:7000/ &> /root/outftp.txt
if [ $? -ne 0 ]; then
#    echo "FTP is down in "$line":7000.Check ASAP.And output is/n" &>> /root/outftp.txt
#i=" ${sed -i '$ d' outftp.txt}"
#sed -i '1 i\$i' outftp.txt
echo "FTP is down in "$line":7000.Check ASAP" | mailx -S smtp=10.11.0.228 -r backup@abc.com  -s "$(echo -e "FTP Down in "$line":7000\nX-Priority: 1")"  -c martin@abc.com jon@abccom < /root/outftp.txt
fi
done <"$file"
#rm -rf /root/outftp.txt

#file content of /root/ftpip.txt
192.168.1.2
10.11.0.2