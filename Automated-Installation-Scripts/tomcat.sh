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




###############procees check#########################
process="$(ps -aux |grep tomcat | grep -v "grep" | awk '{print $2}')"
if ! $process; then
echo "process is running"



ps -aux |grep tomcat |grep -o -P '(?<=-Dcatalina.base=).*(?=-Dcatalina.home)' >> /root/test3.txt

file="/root/test3.txt"
while IFS= read -r line
do
cd $line
p=" $(cat RELEASE-NOTES |grep -w "Apache Tomcat Version" |awk '{print $1$2$3$4}' |grep -o 9.0.5 )"
echo -e   "$p"   >> /root/test4.txt
done <"$file"

z=" $( cat /root/test4.txt |grep -o 9.0.5)"
echo "$z"
min=$(echo $z 9.0.5 | awk '{if ($z = $2) printf "sameversion\n"; else printf "notsame\n"}')
echo "$min"
while [ "$min" = "sameversion" ]
do
echo "same available version is running"
rm -rf /root/test3.txt /root/test4.txt


#break
exit
done


else
echo "process is not running"
fi


kill -9 $process > /dev/null

##############filecheck########################
find / -name RELEASE-NOTES >> /root/test1.txt
file="/root/test1.txt"
while IFS= read -r line
do
j=" $(cat "$line" |grep -w "Apache Tomcat Version" |awk '{print $1$2$3$4}' )"
echo -e  " "$j" path = "$line""  >> /root/test2.txt
done <"$file"



k=" $(cat /root/test2.txt |grep 9.0.5 |awk '{print $1}' )"

min1=$(echo $k 9.0.5 | awk '{if ($k = $2) printf "sameversion\n"; else printf "notsame\n"}')
echo "$min1"
while [ "$min1" = "sameversion" ]
do
#echo "insert to script exit when same version available"
echo "hi"
q=" $(cat /root/test2.txt |grep 9.0.5 |awk '{print $4}' |sed 's/RELEASE-NOTES/bin/g')"
cd $q
sh catalina.sh start
        if ps aux | grep "catalina.startup.Bootstrap" | grep -v "grep" | awk '{print $2}'> /dev/null
                then
                echo "tomcat service is started successfully"
                else
                echo "tomcat service is failed to start. See \"journalctl -xe\" for details";

        fi
rm -rf test2.txt test1.txt
#break
exit
done

function tomcatinstall() {
                echo -n "would want to install Tomcat-9.0.5 (y/n)? "
                old_stty_cfg=$(stty -g)
                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                if echo "$answer" | grep -iq "^y" ;then
                        echo "Yes"
                        yum install wget -y  > /dev/null
                        yum install  nc -y > /dev/null
                        yum install  epel-release -y > /dev/null
                        yum install  haveged -y > /dev/null
                        systemctl start haveged.service
                        systemctl enable haveged.service

                        echo -n "Enter the directory path to install tomcat : ";read a;
                        #mkdir $a;
                                                echo -n "Adding tomcat users"
                        groupadd tomcat;
                                                #useradd -s /bin/nologin -g tomcat -d $a tomcat;
                        useradd tomcat -m -d $a -g tomcat
                        wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.5/bin/apache-tomcat-9.0.5.tar.gz
                        mv apache-tomcat-9.0.5.tar.gz $a
                        cd $a;
                        tar zxvf apache-tomcat-9.0.5.tar.gz;
                        cd $a/apache-tomcat-9.0.5;
                        chgrp -R tomcat conf
                        chmod g+rwx conf
                        chmod g+r conf/*
                        chown -R tomcat logs/ temp/ webapps/ work/
                        chgrp -R tomcat bin
                        chgrp -R tomcat lib
                        chmod g+rwx bin
                        chmod g+r bin/*
                        echo "creating tomcat service file"
                        echo -e "[Unit] \nDescription=Apache Tomcat Web Application Container \nAfter=syslog.target network.target \n[Service] \nType=forking \nEnvironment=JAVA_HOME=$JAVA_HOME \nEnvironment=CATALINA_PID=$a/apache-tomcat-9.0.5/temp/tomcat.pid \nEnvironment=CATALINA_HOME=$a/apache-tomcat-9.0.5 \nEnvironment=CATALINA_BASE=$a/apache-tomcat-9.0.5 \nEnvironment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC' \nEnvironment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom' \nExecStart=$a/apache-tomcat-9.0.5/bin/startup.sh \nExecStop=/bin/kill -15 \$MAINPID \nUser=tomcat \nGroup=tomcat \n[Install] \nWantedBy=multi-user.target" >> /etc/systemd/system/tomcat.service
                          ########user creation doudt##########################
                        echo -n "Creating Tomcat user please specify name : ";read "user";
                        echo -n "Specify password for created user : ";read "password";
                        sed -i '$i '"<user username=\"$user\" password=\"$password\" roles=\"manager-gui,admin-gui\"/>" $a/apache-tomcat-9.0.5/conf/tomcat-users.xml;
                        sed -i 's/0:0:0:0:0:0:0:1/0:0:0:0:0:0:0:1|^.*$/g' $a/apache-tomcat-9.0.5/webapps/manager/META-INF/context.xml
                        sed -i 's/0:0:0:0:0:0:0:1/0:0:0:0:0:0:0:1|^.*$/g' $a/apache-tomcat-9.0.5/webapps/host-manager/META-INF/context.xml

                        #############port  ############################

                        h="$(cat $a/apache-tomcat-9.0.5/conf/server.xml |grep -o -P '(?<=<Connector port=").*(?=" protocol="HTTP/1.1")')"

            g="$(cat $a/apache-tomcat-9.0.5/conf/server.xml |grep -o -P '(?<=<Server port=").*(?=" shutdown="SHUTDOWN">)')"

            echo -e "connector port= "$h" serverport  = "$g""

            echo -n "would you like to change the port for connector port (y/n)? "
                        old_stty_cfg=$(stty -g)
                        stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                        if echo "$answer" | grep -iq "^y" ;then
                                echo Yes

                                function f1() {
                                  echo -n "Enter the port to assign for tomcat connector port : ";
                                  read r;
                                  nc -v -z -w 3 localhost $r &> /dev/null && f1 || echo "Offline"
                                }; f1;
                                echo -e "the port is available"
                                echo -n "would want to change tomcat connector port number (y/n)? "
                                old_stty_cfg=$(stty -g)
                                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                if echo "$answer" | grep -iq "^y" ;then
								echo "Yes"
								function f2() {
								  echo -n "Enter the port to assign for tomcat server port : ";
								  read s;
								  nc -v -z -w 3 localhost $s &> /dev/null && f1 || echo "Offline"
								}; f2;
								echo -e "The port is available"
								sed -i 's/Server port="$g" shutdown="SHUTDOWN"/Server port="$s" shutdown="SHUTDOWN"/g' $a/apache-tomcat-9.0.13/conf/server.xml
								firewall-cmd --zone=public --permanent --add-port=$s/tcp > /dev/null
								firewall-cmd --reload > /dev/null
								else
								echo "No"
                                fi

                                sed -i 's/Connector port="$h" protocol="HTTP\/1.1"/Connector port="$r" protocol="HTTP\/1.1"/g' $a/apache-tomcat-9.0.13/conf/server.xml
                                firewall-cmd --zone=public --permanent --add-port=$r/tcp > /dev/null
                                firewall-cmd --reload > /dev/null
                                #sh $a/apache-tomcat-9.0.5/bin/catalina.sh start
								systemctl enable /etc/systemd/system/tomcat.service
								systemctl daemon-reload
								systemctl start tomcat
								if  ps aux | grep "catalina.startup.Bootstrap" | grep -v "grep" | awk '{print $2}' > /dev/null
									then
									echo " tomcat service is started successfully"
									else
									echo "tomcat service is failed to start. See \"journalctl -xe\" for details";

								fi
                                exit
                                else
                                echo No
                        fi





                        #sh $a/apache-tomcat-9.0.5/bin/catalina.sh start
						systemctl enable /etc/systemd/system/tomcat.service
						systemctl daemon-reload
						systemctl start tomcat

                        firewall-cmd --zone=public --permanent --add-port=8080/tcp > /dev/null
                        firewall-cmd --reload > /dev/null

                        ##########################process check######################
                        if ps aux | grep "catalina.startup.Bootstrap" | grep -v "grep" | awk '{print $2}'> /dev/null
                                then
                                echo "tomcat service is started successfully"
                                else
                                echo "tomcat service is failed to start. See \"journalctl -xe\" for details";

                        fi

                        else
                        echo "No"
                fi
        };



        x=" $(dmidecode --type memory |grep Size: |grep MB |xargs | awk '{print $2,$5,$8,$11,$14,$17,$20,$23,$26,$29,$32,$35,$38,$41,$44,$47,$50,$53,$56,$59}' | awk  '{ print $1+$2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20 }')"
echo "$x"
if [ $x -ge 4096 ]
                then
                #echo "we can proceed to install"
                                rm -rf /root/version.txt  /root/search.txt
                tomcatinstall;

        else
                echo -n "memory is not sufficient to run ezflow application .If we install performance may be degraded.Do you want to install  (y/n)? "
                old_stty_cfg=$(stty -g)
                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                if echo "$answer" | grep -iq "^y" ;then
                 echo "yes"
                                 rm -rf /root/version.txt  /root/search.txt
								 
                 tomcatinstall;

                 else
                        echo "No"
                fi

   fi