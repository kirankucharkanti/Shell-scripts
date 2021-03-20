#!/bin/bash
date='date '+%Y%m%d%H%M%S''
function urlcheck() {
                input="/root/websiteup.txt"
                while IFS=, read -r APP_URL HTTP_STATUS APP_NAME SERVER_TYPE location
                do
                 if curl -s --head -k $APP_URL | grep "$HTTP_STATUS" > /dev/null;
                 then
                 echo -e "site is up"
                find /root/shellscriptlogs/webmonitorstatus/ -mmin +10080 -type f | grep txt > temp.txt
                for i in `cat temp.txt`
                do
                rm -rf $i
                done
                rm -f temp.txt

                 else
                 echo -e "site is down";
                 echo "$APP_URL,$HTTP_STATUS,$APP_NAME,$SERVER_TYPE,$location"  >> /root/websitetemp.txt
                 sed -i "\;$APP_URL,$HTTP_STATUS,$APP_NAME,$SERVER_TYPE,$location;d" /root/websiteup.txt

                fi
                done < "$input"
                input="/root/websitedown.txt"
                while IFS=, read -r APP_URL HTTP_STATUS APP_NAME SERVER_TYPE location timestamp
                do
                if curl -s --head -k $APP_URL | grep "$HTTP_STATUS" > /dev/null;
                then
                 echo -e "site is up"
                 echo "$APP_URL,$HTTP_STATUS,$APP_NAME,$SERVER_TYPE,$location"  >> /root/websiteup.txt
                 sed -i "\;$APP_URL,$HTTP_STATUS,$APP_NAME,$SERVER_TYPE,$location;d" /root/websitedown.txt
             echo -e "Website UP.Below are the details\nApplication URL: "$APP_URL"\nEnvironment Type: "$SERVER_TYPE"\nHosted on:"$location"\n" | mailx -S smtp=10.11.0.228 -r alert@abc.com  -s "$(echo -e ""$APP_NAME" Website UP")"   -c jag@abc.com magge@abc.com
                 else
                 echo -e "site is down"
newtimestamp=`date '+%Y%m%d%H%M'`
secondsDiff=$( ddiff -i '%Y%m%d%H%M' $timestamp $newtimestamp | sed 's/s//' )
                                 echo -e ""$secondsDiff""
                                if ( [ $secondsDiff -ge 3600 ] );



        #newtimestamp=`date '+%Y%m%d%H%M'`
                                 #secondsDiff=$(( $newtimestamp - $timestamp ))
                                #echo -e ""$secondsDiff""
                                #if [ $secondsDiff -gt 60 ]
                                then
                                echo -e "site is down"
                                echo -e "Website down.Below are the details\nApplication URL: "$APP_URL"\nEnvironment Type: "$SERVER_TYPE"\nHosted on:"$location"\nPlease check the issue ASAP" | mailx -S smtp=10.11.0.228 -r alert@abc.com  -s "$(echo -e "Remainder "$APP_NAME" Website Down")"  -c jag@abc.com magge@abc.com
                                #newtimestamp=`date '+%Y%m%d%H%M%S'`
                                echo -e ""$newtimestamp""
                                sed -i "s/$timestamp/$newtimestamp/g" /root/websitedown.txt
                                echo
                                else
                                echo -e "bye"
                                fi



                 fi
                done < "$input"

                };
if [ -s /root/websitetemp.txt ]
then
     echo "File not empty"
         input="/root/websitetemp.txt"
                while IFS=, read -r APP_URL HTTP_STATUS APP_NAME SERVER_TYPE location
                do
                 if curl -s --head -k $APP_URL | grep "$HTTP_STATUS" > /dev/null;
                 then
                 echo -e "site is up"
                 echo "$APP_URL,$HTTP_STATUS,$APP_NAME,$SERVER_TYPE,$location"  >> /root/websiteup.txt
                 sed -i "\;$APP_URL,$HTTP_STATUS,$APP_NAME,$SERVER_TYPE,$location;d" /root/websitetemp.txt
                 else
                 echo -e "site is down"
                 echo "$APP_URL,$HTTP_STATUS,$APP_NAME,$SERVER_TYPE,$location,`date '+%Y%m%d%H%M'`"  >> /root/websitedown.txt
                 #echo "$APP_URL,$HTTP_STATUS,$APP_NAME,$SERVER_TYPE,$location,`date '+%Y%m%d%H%M%S'`" >> /root/timestamp.txt
                 sed -i "\;$APP_URL,$HTTP_STATUS,$APP_NAME,$SERVER_TYPE,$location;d" /root/websitetemp.txt
                 echo -e "Website down.Below are the details\nApplication URL: "$APP_URL"\nEnvironment Type: "$SERVER_TYPE"\nHosted on:"$location"\nPlease check the issue ASAP" | mailx -S smtp=10.11.0.228 -r alert@abc.com  -s "$(echo -e ""$APP_NAME" Website Down\nX-Priority: 1")"  -c jag@abc.com magge@abc.com
                fi

done < "$input"
                urlcheck;
else
     echo "File empty"
         urlcheck;
fi

# file content of /root/websiteup.txt

https://adf.abc.com/Views/Layout.html,200,TVG,UAT,172.16.0.4(India DMZ)
http://jjs.abc.ai/Views/Layout.html,200,Beta,UAT,172.16.0.4(India DMZ)
http://nkjzd.abc.ai/swagger/index.html,404,BetaAPI,UAT,172.16.0.4(India DMZ)