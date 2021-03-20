          function kafkainstall1() {

        #####################process check###########################
        process1=" $(ps aux | grep "server.properties" | grep -v "grep" | awk '{print $2}')"
        if ! $process1; then
                        echo "process is running"
                        y1=" $(ps aux | grep "server.properties" | grep -v "grep" |rev |awk '{print $6}' |rev | sed 's/\-Dkafka.logs.dir=//g' | sed 's/\/bin\/..\/logs//g')"
                        z1=" $(  find $y -name *-site-docs.tgz |grep -o 2.11-1.1.0 | sed -n '1!p') "

        if [ $z1 = "2.11-1.1.0" ]; then
          echo "same available version is running kafka2.11-1.1.0'"
                exit
         else
         echo "not same "

        fi
        else
        echo "no process is running"
        fi
		kill -9 $process1 > /dev/null

        #########################file version chech########################################################



        #find / -name *-site-docs.tgz |awk -F /site-docs/ '{print $2}' | sed -e 's/-site-docs.tgz//g' |sed -e 's/kafka_2.11-//g' > version.txt
        find / -name *-site-docs.tgz >> /root/version2.txt

        cat /root/version2.txt  | awk -F /site-docs/ '{print $2}' | sed -e 's/-site-docs.tgz//g' |sed -e 's/kafka_//g' >> /root/version1.txt

        f1="$( cat /root/version1.txt | grep "2.11-1.1.0")"






        if [ "$f1" = "2.11-1.1.0" ]; then
          echo "same version  is available"
          g="$(cat /root/version2.txt  | grep -0 "2.11-1.1.0" | sed 's/\/site-docs\/kafka_2.11-1.1.0-site-docs.tgz//g')"
         echo "$g"
         nohup env JMX_PORT=4342 $g/bin/kafka-server-start.sh $g/config/server.properties &
         nohup env JMX_PORT=4343 $g/bin/connect-distributed.sh $g/config/connect-distributed.properties &
         exit
         else
         echo "Required vaersion is not available we are going to install"
        fi





                function kafkainstall() {
                        echo -n "would want to install kafka-2.11-1.1.0(y/n)? "
                        old_stty_cfg=$(stty -g)
                        stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                        if echo "$answer" | grep -iq "^y" ;then
                                echo "yes"
                                yum install wget nc > /dev/null
                                echo -n "Enter the directory path to install kafka : ";read a1;
                                mkdir $a1;
                                wget https://archive.apache.org/dist/kafka/1.1.0/kafka_2.11-1.1.0.tgz
                                mv kafka_2.11-1.1.0.tgz $a1
                                cd $a1;
                                tar xvf kafka_2.11-1.1.0.tgz
                                cd kafka_2.11-1.1.0

                                echo -n "Enter the kafka logs path to store : ";read b1;
                                echo -n "Enter the boker id of the zookeeper : ";read c1;
                                echo -n "Enter the advertized host IP address of kafka : ";read d1;
                                echo -n "Enter the plugins path : ";read e1;
                                mkdir $e1;
                                 echo -n "Enter the zookeeper ip address : ";read f1;
                                sed -i '/log.dirs=/c\log.dirs='$b1'' $a1/kafka_2.11-1.1.0/config/server.properties
                                sed -i '/broker.id=/c\broker.id='$c1'' $a1/kafka_2.11-1.1.0/config/server.properties
                                sed -i 's/zookeeper.connect=localhost/zookeeper.connect='$f1'/g'   $a1/kafka_2.11-1.1.0/config/server.properties
                                #echo -e advertised.host.name=$d1 >> $a1/kafka_2.11-1.1.0/config/server.properties
                                sed -i "37i advertised.host.name=$d1" $a1/kafka_2.11-1.1.0/config/server.properties
                                sed -i '/#plugin.path=/c\plugin.path='$e1''  $a1/kafka_2.11-1.1.0/config/connect-distributed.properties


                                firewall-cmd --zone=public --permanent --add-port=2888-3888/tcp > /dev/null
                                firewall-cmd --zone=public --permanent --add-port=4342/tcp > /dev/null
                                firewall-cmd --zone=public --permanent --add-port=9092/tcp > /dev/null
                                firewall-cmd --zone=public --permanent --add-port=4343/tcp > /dev/null
                                firewall-cmd --reload > /dev/null

                                nohup env JMX_PORT=4342 $a1/kafka_2.11-1.1.0/bin/kafka-server-start.sh $a1/kafka_2.11-1.1.0/config/server.properties &
                                nohup env JMX_PORT=4343 $a1/kafka_2.11-1.1.0/bin/connect-distributed.sh $a1/kafka_2.11-1.1.0/config/connect-distributed.properties &
                                #sh $a1/kafka_2.11-1.1.0/bin/kafka-server-start.sh $a1/kafka_2.11-1.1.0/config/server.properties & > /dev/null &
                                #sh $a1/kafka_2.11-1.1.0/bin/connect-distributed.sh $a1/kafka_2.11-1.1.0/config/connect-distributed.properties & > /dev/null &







                                exit
                                else
                                echo "No"
                        fi


                };


        if [ $x -ge 4096 ]
                                        then
                                        #echo "we can proceed to install"
                                        rm -rf /root/version.txt  /root/version1.txt
                                        kafkainstall;

                        else
                                        echo -n "memory is not sufficient to run ezflow application .If we install performance may be degraded.Do you want to install (y/n)? (y/n)? "
                                        old_stty_cfg=$(stty -g)
                                        stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                        if echo "$answer" | grep -iq "^y" ;then
                                         echo "yes"
                                         rm -rf /root/version.txt  /root/version1.txt
                                         kafkainstall;

                                         else
                                                        echo "No"
                                        fi

           fi

   };



function zookeeperinstall1() {
        #!/bin/bash
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
        process=" $(ps aux | grep "zookeeper.server" | grep -v "grep" | awk '{print $2}')"
        #echo $x
        if ! $process; then
        echo "process is running"
        y=" $(ps aux | grep "zookeeper.server" | grep -v "grep" |rev |awk '{print $1}' |rev |awk -F '\\/bin' '{print $1}')"
        z=" $(cat $y/build.xml |grep '"version" value="' |head -1 |rev | awk '{print $2}' |rev |sed -e 's/"//g' |sed -e 's/value=//g') "
        echo "$z"
        min=$(echo $z 3.4.10 | awk '{if ($z = $2) printf "sameversion\n"; else printf "notsame\n"}')
        echo "$min"
        while [ "$min" = "sameversion" ]
        do
        echo "same available version is running"

        kafkainstall1;
        #break
        exit
        done


        else
        echo "process is not running"
        fi

        kill -9 $process > /dev/null
        ##############filecheck########################
        find / -name zkEnv.sh |sed -e 's/\/tests\/zkServer.sh//g' >> /root/search.txt
        sed -i 's/bin\/zkEnv.sh/build.xml/g' /root/search.txt

        file="/root/search.txt"
        while IFS= read -r line
        do
        p=" $(cat "$line" |grep '"version" value="' |head -1 |rev | awk '{print $2}' |rev |sed -e 's/"//g' |sed -e 's/value=//g')"
        echo -e "zookeeper version "$p" path = "$line"" >> /root/version.txt
        done <"$file"



        e=" $(cat /root/version.txt |grep 3.4.10 |awk '{print $3}' )"

        min1=$(echo $e 3.4.10 | awk '{if ($z = $2) printf "sameversion\n"; else printf "notsame\n"}')
        echo "$min1"
        while [ "$min1" = "sameversion" ]
        do
        #echo "insert to script exit when same version available"
        echo "hi"
        q=" $(cat /root/version.txt |grep 3.4.10 |awk '{print $6}' |sed -e 's/build.xml/bin/g')"
        cd $q
        sh zkServer.sh start
                if ps aux | grep "zookeeper.server" | grep -v "grep" | awk '{print $2}' > /dev/null
                        then
                        echo "zookeeper service is started successfully"
                        else
                        echo "zookeeper service is failed to start. See \"journalctl -xe\" for details";

                fi
        #break
        rm -rf /root/version.txt  /root/search.txt
        kafkainstall1;
        exit
        done

                function zookeeperinstall() {
                                echo -n "would want to install zookeeper-3.4.10 (y/n)? "
                                old_stty_cfg=$(stty -g)
                                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                if echo "$answer" | grep -iq "^y" ;then
                                        yum install wget nc > /dev/null
                                        echo -n "Enter the directory path to install zookeeper : ";read a;
                                        echo -n "Enter the  path to store zookeeper data : ";read b;
                                        echo -n "Enter the  path to store zookeeper logs : ";read c;
                                        echo -n "Enter the  IP address zookeeper  : ";read d;
                                        echo -n "Provide myid for zookeeper : ";read myid;
                                        mkdir $a;
                                        wget https://apache.org/dist/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz

                                        mv zookeeper-3.4.10.tar.gz $a;
                                        cd $a;
                                        tar zxvf  zookeeper-3.4.10.tar.gz;
                                        ln -s $a/zookeeper-3.4.10 $a/zookeeper
                                        cd $a/zookeeper
                                        mkdir  $b $c $b/zookeeper $c/zookeeper

                                        echo $myid >> $b/zookeeper/myid ;
                                        cp  $a/zookeeper/conf/zoo_sample.cfg $a/zookeeper/conf/zoo.cfg
                                        sed -e '/dataDir/ s/^#*/#/' -i $a/zookeeper/conf/zoo.cfg
                                        sed -i '/#dataDir=\/tmp\/zookeeper/a dataDir='$b'/zookeeper' $a/zookeeper/conf/zoo.cfg
                                        echo dataLogDir=$c/zookeeper >> $a/zookeeper/conf/zoo.cfg

                                        echo server.$myid=$d:2888:3888 >> $a/zookeeper/conf/zoo.cfg
                                         echo -e "Zookeeper Defined port is allowed at firewall"
                                         grep -oP "clientPort=\s+\K\w+" $a/zookeeper/conf/zoo.cfg
                                                echo -n "would you like to change the port (y/n)? "
                                                old_stty_cfg=$(stty -g)
                                                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                                if echo "$answer" | grep -iq "^y" ;then
                                                        echo Yes

                                                        function f1() {
                                                          echo -n "Enter the port to assign for elasticsearch : ";
                                                          read r;
                                                          nc -v -z -w 3 localhost $r &> /dev/null && f1 || echo "Offline"
                                                        }; f1;
                                                        echo -e "the port is available"
                                                        echo -e "changing port number in /etc/elasticsearch/elasticsearch.yml"

                                                        sed -i '/clientPort=/c\clientPort='$r'' $a/zookeeper/conf/zoo.cfg

                                                        firewall-cmd --zone=public --permanent --add-port=$r/tcp > /dev/null
                                                        firewall-cmd --reload > /dev/null
                                                        cd $c/zookeeper
                                                        sh $a/zookeeper/bin/zkServer.sh start
                                                                if ps aux | grep "zookeeper.server" | grep -v "grep" | awk '{print $2}' > /dev/null
                                                                        then
                                                                        echo "zookeeper service is started successfully"
                                                                        else
                                                                        echo "zookeeper service is failed to start. See \"journalctl -xe\" for details";

                                                                fi
                                                                kafkainstall1;
                                                                exit
                                                        else
                                                        echo No
                                                fi


                                          echo -e "**********************opening port****************************************"
                                                firewall-cmd --zone=public --permanent --add-port=2181/tcp > /dev/null

                                                firewall-cmd --reload > /dev/null

                                                echo -e "******************starting elasticsearch service*****************************"
                                        cd $c/zookeeper

                                        sh $a/zookeeper/bin/zkServer.sh start
                                        if ps aux | grep "zookeeper.server" | grep -v "grep" | awk '{print $2}' > /dev/null
                                                then
                                                echo "zookeeper service is started successfully"
                                                else
                                                echo "zookeeper service is failed to start. See \"journalctl -xe\" for details";
                                        fi
                                        else
                                        echo "No"
                                fi


                };



        if [ $x -ge 4096 ]
                                        then
                                        #echo "we can proceed to install"
                                        rm -rf /root/version.txt  /root/search.txt
                                        zookeeperinstall;

                        else
                                        echo -n "memory is not sufficient to run ezflow application .If we install performance may be degraded.Do you want to install (y/n)? (y/n)? "
                                        old_stty_cfg=$(stty -g)
                                        stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                                        if echo "$answer" | grep -iq "^y" ;then
                                         echo "yes"
                                         rm -rf /root/version.txt  /root/search.txt
                                         zookeeperinstall;

                                         else
                                                        echo "No"
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


   x=" $(dmidecode --type memory |grep Size: |grep MB |xargs | awk '{print $2,$5,$8,$11,$14,$17,$20,$23,$26,$29,$32,$35,$38,$41,$44,$47,$50,$53,$56,$59}' | awk  '{ print $1+$2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20 }')"
        echo "$x"
        if [ $x -ge 4096 ]
        then

                zookeeperinstall1;
                kafkainstall1


        else
        echo -n "memory is not sufficient to run ezflow application .If we install performance may be degraded.Do you want to install (y/n)? "
                old_stty_cfg=$(stty -g)
                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                if echo "$answer" | grep -iq "^y" ;then
					echo "yes"
                        zookeeperinstall1;
                        kafkainstall1;
                        else
                        echo "No"
                fi

   fi
