#!/bin/bash
ip=$(ip route get 1.2.3.4 | awk '{print $7}')
df -H | awk '
    NR == 1 {next}
    $1 == "abc:/xyz/pqr" {next}
    $1 == "tmpfs" {next}
    $1 == "/dev/cdrom" {next}
    1 {sub(/%/,"",$5); print $1, $5, $6}' > /tmp/check.txt
sed --in-place '/\/boot/d' /tmp/check.txt

input="/tmp/check.txt"
while IFS= read -r line
do
#j= $( cat "$line"  | awk '{print $5}' | sed 's/%//')
j=$(echo "$line"  | awk '{print $2}')
h=$(echo "$line"  | awk '{print $1}')
i=$(echo "$line"  | awk '{print $3}')
ip=$(ip route get 1.2.3.4 | awk '{print $7}')
if [ "$j" -ge 85 ]
                then
                #echo "we can proceed to install"
         echo -e "Disk size increasing on mount point "$h" and  disk size reached to "$j" %  `date`"  >> /tmp/check1.txt
          echo "disksize" >> /tmp/diskmonitor.txt
                        cd $i
                        du -hs * | sort -rh | head -10 >> /tmp/check1.txt

   fi
done < "$input"

file4="/tmp/check1.txt"
if [ -f "$file4" ]
then
echo "" | mailx -S smtp=10.11.0.228 -r alert@epsoftinc.com  -s "$(echo -e "Storage alert in "$ip"\nX-Priority: 1")" italerts@epsoftinc.com < /tmp/check1.txt
        echo " found."
else
        echo "not found."
fi

rm -rf /tmp/check1.txt

find /root/shellscriptlogs/vmmonitorstaus/ -mmin +10080 -type f | grep txt > temp.txt
for i in `cat temp.txt`
do
rm -rf $i
done
rm -f temp.txt



##cpu Monitor##


function backup1(){
cpu=$(top -bn1 | grep Cpu | awk '{print $2}'|  cut -d "." -f 1 | cut -d "," -f 1)
cpu1=55
if [[ "$cpu" -ge "$cpu1" ]]; then
echo -e "hi"
 echo -e "CPU Current Usage is: "$cpu" % " >> /tmp/cpuprocess.txt
        ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head >> /tmp/cpuprocess.txt
echo "" | mailx -s smtp=10.11.0.228 -r alert@epsoftinc.com  -s "$(echo -e "CPU Load Is High on "$ip"\nX-Priority: 1")" kiran.kucharkanti@epsoftinc.com < /tmp/cpuprocess.txt
echo "cpuload,`date '+%Y%m%d%H%M'`" >> /tmp/cpumonitor.txt
fi
rm -rf /tmp/cpuprocess.txt
};
if [ -f /tmp/cpumonitor.txt ]
then
if [ -s /tmp/cpumonitor.txt ];
then
echo "File not empty"

input="/tmp/cpumonitor.txt"
while IFS=, read -r text timestamp
do
file="/tmp/cpumonitor.txt"
        a=$(grep -i cpuload /tmp/cpumonitor.txt | cut -d "," -f 1)
echo -e ""$a""
b="cpuload"
#echo -e ""$b""
   if [ "$a" = "$b" ];
                        then
                        echo "found."
                        cpu2=$(top -bn1 | grep Cpu | awk '{print $2}'|  cut -d "." -f 1 | cut -d "," -f 1)
                        cpu3=45
                                if [ "$cpu2" -le "$cpu3" ];
                                         then
                                        echo
                                        sed -i "/cpuload/d" /tmp/cpumonitor.txt
                                        echo "Current CPU Load is "$cpu2"" | mailx -s smtp=10.11.0.228 -r alert@epsoftinc.com  -s "$(echo -e "CPU Load Is Decreased on "$ip"")" kiran.kucharkanti@epsoftinc.com
                                        else
                                        newtimestamp=`date '+%Y%m%d%H%M'`
                                        secondsDiff=$( ddiff -i '%Y%m%d%H%M' $timestamp $newtimestamp | sed 's/s//' )
                                         echo -e ""$secondsDiff""
                                                if [ $secondsDiff -ge 30 ];
                                                        then
                                                        cpu4=$(top -bn1 | grep Cpu | awk '{print $2}'|  cut -d "." -f 1 | cut -d "," -f 1)
                                                        echo -e "CPU Current Usage is: "$cpu" % " >> /tmp/cpuprocess.txt
                                                   sed -i "s/$timestamp/$newtimestamp/g" /tmp/cpumonitor.txt
                                                   echo "" | mailx -s smtp=10.11.0.228 -r alert@epsoftinc.com  -s "$(echo -e "Reminder: CPU Load Is High on "$ip"\nX-Priority: 1")" kiran.kucharkanti@epsoftinc.com < /tmp/cpuprocess.txt
                                                        rm -rf /tmp/cpuprocess.txt
                                                 fi

                                fi
               fi
break
done < "$input"
else
     echo "File empty"
backup1;
fi
else
    echo "File not exists"
backup1;
fi


##Memory Monitor##
function backup2(){
free=$(free -t | awk 'FNR == 2 {print $3/$2*100}' |  cut -d "." -f 1 | cut -d "," -f 1)
if [[ "$free" -ge 4 ]]; then
       echo -e "server memory is running low!\n\nUsed memory: $free % on  `date`\n\n "$file" \n\n" >> /tmp/memoryprocess.txt
        ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head >> /tmp/memoryprocess.txt
                echo "memoryload,`date '+%Y%m%d%H%M'`" >> /tmp/memorymonitor.txt
        #file=$(echo /tmp/memoryprocess.txt)
echo "" | mailx -s smtp=10.11.0.228 -r alert@epsoftinc.com  -s "$(echo -e "Memory alert in"$ip"\nX-Priority: 1")" kiran.kucharkanti@epsoftinc.com < /tmp/memoryprocess.txt
rm -rf /tmp/memoryprocess.txt
fi
};
if [ -f /tmp/memorymonitor.txt ]
then
if [ -s /tmp/memorymonitor.txt ];
then
echo "File not empty"

input="/tmp/memorymonitor.txt"
while IFS=, read -r text timestamp
do
file="/tmp/memorymonitor.txt"
        c=$(grep -i memoryload /tmp/memorymonitor.txt | cut -d "," -f 1)
echo -e ""$a""
d="memoryload"
#echo -e ""$b""
   if [ "$a" = "$b" ];
                        then
                        free1=$(free -t | awk 'FNR == 2 {print $3/$2*100}' |  cut -d "." -f 1 | cut -d "," -f 1)
                                if [[ "$free1" -le 9 ]]; then
                                sed -i "/memoryload/d" /tmp/memorymonitor.txt
                                echo -e "server memory is normal!\n\nUsed memory: $free % on  `date`\n\n "$file" \n\n" >> /root/cpu.txt
                                echo "Current Memory Usage is "$free1"" | mailx -s smtp=10.11.0.228 -r alert@epsoftinc.com  -s "$(echo -e "Memory load decreased in"$ip"")" kiran.kucharkanti@epsoftinc.com
                                sed -i "/$text,$timestamp/d" /tmp/memorymonitor.txt
                                                                                else
										#install dateutils for time comparsion										
                                        newtimestamp=`date '+%Y%m%d%H%M'`
                                        secondsDiff=$( ddiff -i '%Y%m%d%H%M' $timestamp $newtimestamp | sed 's/s//' )
                                         echo -e ""$secondsDiff""
                                                if [ $secondsDiff -ge 30 ];
                                                        then
                                                        free2=$(free -t | awk 'FNR == 2 {print $3/$2*100}' |  cut -d "." -f 1 | cut -d "," -f 1)
                                                        echo -e "server memory is running low!\n\nUsed memory: $free % on  `date`\n\n "$file" \n\n" >> /tmp/memoryprocess.txt
                                                                                                                 ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head >> /tmp/memoryprocess.txt
                                                   sed -i "s/$timestamp/$newtimestamp/g" /tmp/memorymonitor.txt
                                                   echo "" | mailx -s smtp=10.11.0.228 -r alert@epsoftinc.com  -s "$(echo -e "Remainder: Memory alert in"$ip"\nX-Priority: 1")" kiran.kucharkanti@epsoftinc.com < /tmp/memoryprocess.txt
                                                        rm -rf /tmp/memoryprocess.txt
                                                 fi

                                fi
               fi
break
done < "$input"
else
     echo "File empty"
backup2;
fi
else
    echo "File not exists"
backup2;
fi
