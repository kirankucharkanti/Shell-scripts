#!/bin/bash


function mongoinstall() {

        if ! rpm -qa |grep -o 'mongodb-org-server......' ; then
                echo -n "would want to install mongodb 3.6.4 (y/n)? "
                old_stty_cfg=$(stty -g)
                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                if echo "$answer" | grep -iq "^y" ;then
				 echo "yes"
                    echo -e "[mongodb-org-3.6] \nname=MongoDB Repository \nbaseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.6/x86_64/ \ngpgcheck=1 \nenabled=1 \ngpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc" >>/etc/yum.repos.d/mongodb-org-3.6.repo

                        yum install -y nc mongodb-org-3.6.4 mongodb-org-server-3.6.4 mongodb-org-shell-3.6.4 mongodb-org-mongos-3.6.4 mongodb-org-tools-3.6.4

                        echo -e "Mongo Defined port is allowed at firewall"
                        grep -oP "port:\s+\K\w+" /etc/mongod.conf
                        echo -n "would you like to change the port (y/n)? "
                        old_stty_cfg=$(stty -g)
                        stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                if echo "$answer" | grep -iq "^y" ;then
                                        echo Yes

                                        function port() {
                                          echo -n "Enter the port to assign for mongodb : ";
                                          read a;
                                          nc -v -z -w 3 localhost $a &> /dev/null && f1 || echo "Offline"
                                        }; port;

                                        echo -e "the port is available"
                                        echo -e "changing port number in /etc/mongod.conf"
                                      # sed -i '/  port:/s/^/#/g'  /etc/mongod.conf ;
                                       # echo   port: $a >> /etc/mongod.conf
                                        sed -i '/port:/c\  port: '$a'' /etc/mongod.conf

                                        firewall-cmd --zone=public --permanent --add-port=$a/tcp > /dev/null
                                        firewall-cmd --reload > /dev/null

                                        systemctl daemon-reload
                                        systemctl enable mongod
                                        systemctl start mongod
											if pgrep -x "mongod" > /dev/null
													then
													echo "mongod service is started successfully"
													else
													echo "mongod service is failed to start. See \"journalctl -xe\" for details";



											fi

                                exit
                                else
                                        echo No
                                fi


                                echo -e "**********************opening port****************************************"
                                firewall-cmd --zone=public --permanent --add-port=27017/tcp > /dev/null
                                firewall-cmd --reload > /dev/null

                                echo -e "******************starting mongodb service*****************************"
                                systemctl daemon-reload
                                systemctl enable mongod
                                systemctl start mongod

									if pgrep -x "mongod" > /dev/null
											then
											echo "mongod service is started successfully"
											else
											echo "mongod service is failed to start. See \"journalctl -xe\" for details";

									fi



				exit
                else
                        echo No
						exit
                fi

         else

                currentver="$(rpm -qa |grep -o 'mongodb-org-server......')"
                requiredver="mongodb-org-server-3.6.4"

                if [ "$currentver" = "$requiredver" ]; then
                        echo "version is up to date";
                        exit
                else
                        if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then

                                ##############Downgrade#################
                                echo -n "would want to downgrade  mongodb 3.6.4,data may losss (y/n)? "

                                old_stty_cfg=$(stty -g)
                                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                if echo "$answer" | grep -iq "^y" ; then
								 echo "yes"
                                        echo -e "**********************stoping mongodb service*****************************"
                                        systemctl stop mongod
                                        systemctl disable mongod
                                        systemctl daemon-reload

                                         echo -e "[mongodb-org-3.6] \nname=MongoDB Repository \nbaseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.6/x86_64/ \ngpgcheck=1 \nenabled=1 \ngpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc" >>/etc/yum.repos.d/mongodb-org-3.6.repo

                                     yum downgrade -y nc mongodb-org-3.6.4 mongodb-org-server-3.6.4 mongodb-org-shell-3.6.4 mongodb-org-mongos-3.6.4 mongodb-org-tools-3.6.4

                                        echo -e "Mongo Defined port is allowed at firewall"
                                        grep -oP "port:\s+\K\w+" /etc/mongod.conf
                                        echo -n "would you like to change the port (y/n)? "

                                        old_stty_cfg=$(stty -g)
                                        stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                                if echo "$answer" | grep -iq "^y" ;then
                                                        echo Yes
                                                        function port1() {
                                                          echo -n "Enter the port to assign for mongodb : ";
                                                          read b;
                                                          nc -v -z -w 3 localhost $b &> /dev/null && f1 || echo "Offline"
                                                        }; port1;

                                                        echo -e "the port is available"
                                                        echo -e "changing port number in /etc/mongod.conf"
                                                        #sed -i '/  port:/s/^/#/g'  /etc/mongod.conf ;
                                                        #echo   port: $b >> /etc/mongod.conf
                                                        sed -i '/port:/c\  port: '$b'' /etc/mongod.conf
                                                        firewall-cmd --zone=public --permanent --add-port=$b/tcp> /dev/null
                                                        firewall-cmd --reload > /dev/null

                                                        systemctl daemon-reload
                                                        systemctl enable mongod
                                                        systemctl start mongod
															if pgrep -x "mongod" > /dev/null
																	then
																	echo "mongod service is started successfully"
																	else
																	echo "mongod service is failed to start. See \"journalctl -xe\" for details";

															fi
                                                        exit

                                                else
                                                        echo No
                                                fi

                                        echo -e "***************************opening port********************************"
                                        firewall-cmd --zone=public --permanent --add-port=27017/tcp > /dev/null
                                        firewall-cmd --reload > /dev/null

                                        echo -e "starting mongodb service*****************************"
                                        systemctl daemon-reload
                                        systemctl enable mongod
										systemctl start mongod
											if pgrep -x "mongod" > /dev/null
													then
													echo "mongod service is started successfully"
													else
													echo "mongod service is failed to start. See \"journalctl -xe\" for details";

											fi
											
                                else
                                        echo No
                                        exit
                                fi
                        else
                                #echo "test"
                                echo -n "would want to update to mongodb 3.6.4,take backup data may loss (y/n)? "

                                old_stty_cfg=$(stty -g)
                                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty
                                        if echo "$answer" | grep -iq "^y" ;then
										 echo "yes"
                                                echo -e "***********************stoping mongodb service*****************************"
                                                systemctl stop mongod
                                                systemctl disable mongod
                                                 systemctl daemon-reload
                                              echo -e "[mongodb-org-3.6] \nname=MongoDB Repository \nbaseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.6/x86_64/ \ngpgcheck=1 \nenabled=1 \ngpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc" >>/etc/yum.repos.d/mongodb-org-3.6.repo

                                                yum update -y nc mongodb-org-3.6.4 mongodb-org-server-3.6.4 mongodb-org-shell-3.6.4 mongodb-org-mongos-3.6.4 mongodb-org-tools-3.6.4


                                                echo -e "Mongo Defined port is allowed at firewall"

                                                grep -oP "port:\s+\K\w+" /etc/mongod.conf

                                                echo -n "would you like to change the port (y/n)? "

                                                old_stty_cfg=$(stty -g)
                                                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty
                                                if echo "$answer" | grep -iq "^y" ;then
                                                        echo Yes
                                                        function port2() {
                                                          echo -n "Enter the port to assign for mongodb : ";
                                                          read c;
                                                          nc -v -z -w 3 localhost $c &> /dev/null && f1 || echo "Offline"

                                                        }; port2;

                                                        echo -e "the port is available"
                                                        echo -e "changing port number in /etc/mongod.conf"
                                                        #sed -i '/  port:/s/^/#/g'  /etc/mongod.conf ;
                                                        #echo   port: $c >> /etc/mongod.conf
                                                        sed -i '/port:/c\  port: '$c'' /etc/mongod.conf
                                                        firewall-cmd --zone=public --permanent --add-port=$c/tcp > /dev/null
                                                        firewall-cmd --reload > /dev/null

                                                        systemctl daemon-reload
                                                        systemctl enable mongod
                                                        systemctl start mongod
														if pgrep -x "mongod" > /dev/null
																then
																echo "mongod service is started successfully"
																else
																echo "mongod service is failed to start. See \"journalctl -xe\" for details";

														fi
                                                        exit

                                                else
                                                        echo No
                                                fi
                                        echo -e "********************opening port****************************************"
                                        firewall-cmd --zone=public --permanent --add-port=27017/tcp > /dev/null
                                        firewall-cmd --reload > /dev/null

                                        echo -e "*****************starting mongodb service*****************************"
                                        systemctl daemon-reload
                                        systemctl enable mongod
                                        systemctl start mongod
											if pgrep -x "mongod" > /dev/null
													then
													echo "mongod service is started successfully"
													else
													echo "mongod service is failed to start. See \"journalctl -xe\" for details";

											fi
                                else
                                        echo No
                                        exit
                                fi
                        fi
                fi
        fi
}; 
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




x=" $(dmidecode --type memory |grep Size: |grep MB |xargs | awk '{print $2,$5,$8,$11,$14,$17,$20,$23,$26,$29,$32,$35,$38,$41,$44,$47,$50,$53,$56,$59}' | awk  '{ print $1+$2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20 }')"
echo "$x"
if [ $x -ge 6144 ]
		then
		#echo "we can proceed to install"
		mongoinstall;
	else
		echo -n "memory is not sufficient to run ezflow application .If we install performance may be degraded.Do you want to install (y/n)? "
		old_stty_cfg=$(stty -g)
		stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

		if echo "$answer" | grep -iq "^y" ;then
		 echo "yes"
		 mongoinstall;
			else
			echo No
		fi
 
   fi