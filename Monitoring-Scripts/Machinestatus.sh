#!/bin/bash
function machinestatuscheck() {
input1="/root/pingstatus.txt"
while IFS=, read -r Up Down Maildown Mailup downtemp
do

input="$Up"
while IFS= read -r line
do

if ping -c 2 -W 1 "$line"; then
  echo "$hostname_or_ip_address is alive"

find /root/shellscriptlogs/pingstatus/ -mmin +10080 -type f | grep txt > temp.txt
                for i in `cat temp.txt`
                do
                rm -rf $i
                done
                rm -f temp.txt

else
  echo "$hostname_or_ip_address is pining for the fjords"
 echo "$line"  >> $downtemp
 sed -i "/$line/d" $Up
#echo ""$Maildown" "$line" .Please check ASAP." | mailx -S smtp=10.11.0.228 -r alert@abc.com  -s "$(echo -e ""$Maildown"\nX-Priority: 1")" jon@abc.com
fi
done < "$input"
input="$Down"
while IFS=, read -r ip timestamp
do

if ping -c 3 -W 1 "$ip"; then
  echo "$hostname_or_ip_address is alive"
 echo "$ip"  >> $Up
sed -i "\;$ip,$timestamp;d" $Down
echo ""$Mailup" "$ip"" | mailx -S smtp=10.11.0.228 -r alert@abc.com  -s "$(echo -e "$Mailup")"  jon@abc.com

else
echo "$hostname_or_ip_address is pining for the fjords"
#install date utils for comparision
newtimestamp=`date '+%Y%m%d%H%M'`
secondsDiff=$( ddiff -i '%Y%m%d%H%M' $timestamp $newtimestamp | sed 's/s//' )
                                 echo -e ""$secondsDiff""
                                if ( [ $secondsDiff -ge 3600 ] );




#newtimestamp=`date '+%Y%m%d%H%M%'`
#secondsDiff=$(( `date '+%Y%m%d%H%M'` - $timestamp ))
 #                                echo -e ""$secondsDiff""
  #                              if ( [ $secondsDiff -gt 60 ] );
                                then
                                echo -e "machine is down"
                                echo ""$ip" "$Maildown" `date`.Please check the issue ASAP" | mailx -S smtp=10.11.0.228 -r alert@abc.com  -s "$(echo -e "Reminder "$Maildown" ")" jon@abc.com
                                newtimestamp=`date '+%Y%m%d%H%M'`
                                echo -e ""$newtimestamp""
                                sed -i "s/$timestamp/$newtimestamp/g" $Down
                                echo
                                else
                                echo -e "bye"
                                fi


fi
done < "$input"
done < "$input1"
 };

 input3="/root/pingstatus.txt"
while IFS=, read -r Up Down Maildown Mailup downtemp
do
if [ -s $downtemp ]
then
     echo "File not empty"
         input="$downtemp"
                while IFS=, read -r line
                do
                                if ping -c 2 -W 1 "$line"; then
  echo "$hostname_or_ip_address is alive"
  echo "$line"  >> $Up
 sed -i "/$line/d" $downtemp
else
  echo "$hostname_or_ip_address is pining for the fjords"
 echo "$line,`date '+%Y%m%d%H%M'`"  >> $Down
 sed -i "/$line/d" $downtemp
echo ""$Maildown" "$line" .Please check ASAP." | mailx -S smtp=10.11.0.228 -r alert@abc.com  -s "$(echo -e ""$Maildown"\nX-Priority: 1")" jon@abc.com
fi
done < "$input"
#machinestatuscheck;
#exit
else
echo -e "file is empty"
#machinestatuscheck;
#exit
fi
done < "$input3"
machinestatuscheck;



#file content of /root/pingstatus.txt
desktopup.txt,desktopdown.txt,Desktop is down,Desktop is up,desktoptemp.txt
serverup.txt,serverdown.txt,Server is down,Server is up,servertemp.txt
vmup.txt,vmdown.txt,Virtual machine is down,Virtual machine is up,vmtemp.txt

#file content of desktopup.txt,serverup.txt,vmup.txt
192.168.1.1
10.11.0.2