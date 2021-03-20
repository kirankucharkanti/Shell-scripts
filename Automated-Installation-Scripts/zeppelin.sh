#!/bin/bash
########java check####################
m5="$(java -version 2>&1 >/dev/null | grep 'java version' | awk '{print $3}'|sed -e 's/"//g')"
 echo "Java SE version is $m5 installed"

b5=1.8.0_161
if [ $m5 == $b5 ] ;then
echo "same version"
elif [ $m5 != $b5 ];then
  if [ $m5 \< $b5 ];then
  echo "Required Java SE version is 1.8.0_161 please upgrade"
  exit
  fi
  if [ $m5 \> $b5 ];then
  echo "Required Java SE version is 1.8.0_161 please Downgrade"
  exit
 fi
else
echo "please install Java SE version is 1.8.0_161"
exit
fi
############hostname#################
host=$(hostname -f)
echo $host
while [ $host = localhost ]
do
echo -n "Enter the IP address of the system : ";read ipadd;
 echo -n "Enter the fully qualified domain name to assign : ";read name;
 echo $ipadd                $name  >> /etc/hosts
 sudo systemctl restart network
break
done


process=" $(ps aux | grep "zeppelin.server.ZeppelinServer" | grep -v "grep" | awk '{print $2}')"
if ! $process; then
        echo "process is running"
        y=" $(ps aux | grep "zeppelin.server.ZeppelinServer" | grep -v "grep" |rev |awk '{print $5}' |rev | sed 's/\-Dlog4j.configuration=file:\/\///g' | sed 's/\/conf\/log4j.properties//g')"
        z=" $(find $y  -name zeppelin-web-* |grep -o "0.7.0") "
        min=$(echo $z 0.7.0 | awk '{if ($z = $2) printf "sameversion\n"; else printf "notsame\n"}')
        echo "$min"
        while [ "$min" = "sameversion" ]
        do
        echo "same available version is running"
        exit
        done
        else
        echo "process is not running"
        fi


kill -9 $process > /dev/null


##################version check########################
find / -name zeppelin-web-* >> /root/test.txt
file="/root/test.txt"
while IFS= read -r line
do
j=" $( cat "$line"  |grep -o "0.7.0") "
echo -e  " "$j" path = "$line""  >> /root/test1.txt
done <"$file"



k=" $(cat /root/test1.txt |grep 0.7.0  )"

min1=$(echo $k 0.7.0 | awk '{if ($k = $2) printf "sameversion\n"; else printf "notsame\n"}')
echo "$min1"
while [ "$min1" = "sameversion" ]
do

echo "hi"
q="$(cat test.txt  |grep -w "0.7.0" | sed 's/zeppelin-web-0.7.0.war/bin/g')"

cd $q
sh zeppelin.sh start
        if ps aux | grep "zeppelin.server.ZeppelinServer" | grep -v "grep" | awk '{print $2}'> /dev/null
                then
                echo "zeppelin service is started successfully"
                else
                echo "zeppelin service is failed to start. See \"journalctl -xe\" for details";

        fi
#break
exit
done


function zeppelininstall() {
        echo -n "would want to install Zeppelin-0.7.0 (y/n)? "
        old_stty_cfg=$(stty -g)
        stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

        if echo "$answer" | grep -iq "^y" ;then
                echo "Yes"
                yum install wget -y  > /dev/null
                yum install  nc -y > /dev/null
                    cd /root/

                                wget http://archive.apache.org/dist/zeppelin/zeppelin-0.7.0/zeppelin-0.7.0-bin-all.tgz
                                echo -e "330484bfd528ff8868e48d4e4e474d94" > /root/zeppelin-0.7.0-bin-all.tgz.md5.txt
md5sum zeppelin-0.7.0-bin-all.tgz |awk '{print $1}' > /root/zeppelin-0.7.0-bin-all.tgz.md51.txt


                        diff --brief <(sort /root/zeppelin-0.7.0-bin-all.tgz.md5.txt) <(sort /root/zeppelin-0.7.0-bin-all.tgz.md51.txt) >/dev/null
comp_value=$?

if [ $comp_value -eq 1 ]
then
    echo "tar file is corrupted  please delete everything and re-run again"
	exit
else
    #echo "do something because they're identical"
         echo -n "Enter the directory path to install Zeppelin : ";read a;
        #       mkdir $a;
                 echo -n "Adding zeppelin users"
                adduser -d $a -s /sbin/nologin zeppelin
                 chown -R zeppelin:zeppelin $a/




                mv /root/zeppelin-0.7.0-bin-all.tgz $a
        cd $a;
                tar zxvf zeppelin-0.7.0-bin-all.tgz
                cd $a/zeppelin-0.7.0-bin-all
                chown -R zeppelin:zeppelin $a/
                echo -n "Creating Zeppelin service file"
                echo -e "[Unit] \nDescription=Zeppelin service \nAfter=syslog.target network.target \n[Service] \nType=forking \nExecStart=$a/zeppelin-0.7.0-bin-all/bin/zeppelin-daemon.sh start \nExecStop=$a/zeppelin-0.7.0-bin-all/bin/zeppelin-daemon.sh stop \nExecReload=$a/zeppelin-0.7.0-bin-all/bin/zeppelin-daemon.sh reload \nUser=zeppelin \nGroup=zeppelin \nRestart=always \n[Install] \nWantedBy=multi-user.target" >> /etc/systemd/system/zeppelin.service
                cp $a/zeppelin-0.7.0-bin-all/conf/zeppelin-site.xml.template  $a/zeppelin-0.7.0-bin-all/conf/zeppelin-site.xml
                cp $a/zeppelin-0.7.0-bin-all/conf/zeppelin-env.sh.template  $a/zeppelin-0.7.0-bin-all/conf/zeppelin-env.sh
                 sed -i '/# export JAVA_HOME=/c\export JAVA_HOME='$JAVA_HOME'' $a/zeppelin-0.7.0-bin-all/conf/zeppelin-env.sh
                echo -n "Enter the Zeppelin IP address : ";read b;
                sed -i '/<name>zeppelin.server.addr<\/name>/{n;s/.*/  <value>$b<\/value>/}' $a/zeppelin-0.7.0-bin-all/conf/zeppelin-site.xml
                echo -e "Zeppelin Defined port is allowed at firewall 8080"

                echo -n "would you like to change the port (y/n)? "
                old_stty_cfg=$(stty -g)
                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                if echo "$answer" | grep -iq "^y" ;then
                        echo Yes

                        function port() {
                          echo -n "Enter the port to assign for mongodb : ";
                          read c;
                          nc -v -z -w 3 localhost $c &> /dev/null && f1 || echo "Offline"
                        }; port;

                        echo -e "the port is available"
                        echo -e "changing port number in $a/zeppelin-0.7.0-bin-all/conf/zeppelin-site.xml"

                        sed -i '/<name>zeppelin.server.port<\/name>/{n;s/.*/  <value>$c<\/value>/}' $a/zeppelin-0.7.0-bin-all/conf/zeppelin-site.xml

                        firewall-cmd --zone=public --permanent --add-port=$c/tcp > /dev/null
                        firewall-cmd --reload > /dev/null

                   systemctl daemon-reload
                        systemctl enable zeppelin
                        systemctl start zeppelin
                                if ps aux | grep "zeppelin.server.ZeppelinServer" | grep -v "grep" | awk '{print $2}'> /dev/null
                                        then
                                        echo "zeppelin service is started successfully"
                                        else
                                        echo "zeppelin service is failed to start. See \"journalctl -xe\" for details";

                                fi

                        exit
                        else
                                        echo No
                fi




                chown -R zeppelin:zeppelin $a/
                firewall-cmd --zone=public --permanent --add-port=8080/tcp > /dev/null
                firewall-cmd --reload > /dev/null
                systemctl daemon-reload
                systemctl enable zeppelin
                systemctl start zeppelin

                if ps aux | grep "zeppelin.server.ZeppelinServer" | grep -v "grep" | awk '{print $2}'> /dev/null
                        then
                        echo "zeppelin service is started successfully"
                        else
                        echo "zeppelin service is failed to start. See \"journalctl -xe\" for details";
                fi
fi







                else
                echo "NO"
        fi


};

x=" $(dmidecode --type memory |grep Size: |grep MB |xargs | awk '{print $2,$5,$8,$11,$14,$17,$20,$23,$26,$29,$32,$35,$38,$41,$44,$47,$50,$53,$56,$59}' | awk  '{ print $1+$2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20 }')"
echo "$x"
if [ $x -ge 4096 ]
                then
                #echo "we can proceed to install"
                                rm -rf /root/test1.txt  /root/test.txt
                zeppelininstall;

        else
                echo -n "memory is not sufficient to run ezflow application .If we install performance may be dedraded.Do you want to install  (y/n)? "
                old_stty_cfg=$(stty -g)
                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                if echo "$answer" | grep -iq "^y" ;then
                 echo "yes"
                                 rm -rf /root/test1.txt  /root/test.txt
                 zeppelininstall;

                 else
                        echo "No"
                fi

   fi
