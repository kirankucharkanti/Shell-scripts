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
function scala() {
find / -name scala |grep /bin/scala > /root/scalapath.txt
file="/root/scalapath.txt"
    while IFS= read -r line
    do
    p=" $(sh "$line" -version 2>&1 | awk '{print $5}')"
    echo -e "Scala version "$p" path = "$line"" >> /root/scala.txt
   done <"$file"



m="$(cat /root/scala.txt | awk '{print $3}'  |grep -o "2.11.7")"
echo "$m"
if [ "$m" == 2.11.7 ]; then
echo "hi"
sed -e '/export SCALA_HOME=/s/^/#/g' -i /root/.bash_profile
m1="$(cat /root/scala.txt | awk '{print $6}' | grep -w "2.11.7")"
echo -e "export SCALA_HOME=$m1" >> /root/.bash_profile
source /root/.bash_profile
spark;
exit

else
echo "not same we are going to install"

fi





 echo -n "would want to install scala-2.11.7 (y/n)? "
        old_stty_cfg=$(stty -g)
        stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

        if echo "$answer" | grep -iq "^y" ;then
                echo "yes"
                yum install wget -y  > /dev/null
                echo -n "Enter the directory path to install Scala: ";read n;
                wget https://downloads.lightbend.com/scala/2.11.7/scala-2.11.7.tgz
                mkdir $n
                mv scala-2.11.7.tgz $n
                cd $n
                tar xvf scala-2.11.7.tgz
                echo -e "export SCALA_HOME=$n/scala-2.11.7/bin/scala" >> /root/.bash_profile
                source /root/.bash_profile
                spark;
                else
                echo "NO"
                spark;
        fi
};
function spark(){

###########process check########################
process=" $( ps aux | grep "spark.deploy.master" | grep -v "grep" | awk '{print $2}')"
if ! $process; then
        echo "process is running"
        y=" $(ps aux | grep "spark.deploy.master" | grep -v "grep" |rev |awk '{print $10}' |rev | cut -d':' -f1 | sed 's/\/conf\///g')"
        z=" $(find $y -name spark-examples_* | grep -w "2.3.0") "
        min=$(echo $z 2.3.0 | awk '{if ($z = $2) printf "sameversion\n"; else printf "notsame\n"}')
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
#####################version check#############################
find / -name spark-examples_* |grep -w "2.3.0" >> /root/test.txt

k=" $(cat /root/test.txt |grep "2.3.0"  )"

min1=$(echo $k 2.3.0 | awk '{if ($k = $2) printf "sameversion\n"; else printf "notsame\n"}')
echo "$min1"
while [ "$min1" = "sameversion" ]
do

echo "hi"
q="$(cat test.txt  |grep -w "2.3.0" |sed 's/\/examples\/jars\/spark-examples_2.11-2.3.0.jar//g' )"
echo "$q"
cd $q/sbin
sh start-all.sh
        if  ps aux | grep "spark.deploy.master" | grep -v "grep" | awk '{print $2}'> /dev/null
                then
                echo "spark master is started successfully"
                else
                echo "spark master is failed to start. See \"journalctl -xe\" for details";

        fi
        if ps aux | grep "spark.deploy.worker" | grep -v "grep" | awk '{print $2}'> /dev/null
         then
                echo "spark worker is started successfully"
                else
                echo "spark master is failed to start. See \"journalctl -xe\" for details";

        fi
 #break
exit
done


function sparkinstall() {
        echo -n "would want to install spark-2.3.0 (y/n)? "
        old_stty_cfg=$(stty -g)
        stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

        if echo "$answer" | grep -iq "^y" ;then

                echo "yes"
                yum install wget -y  > /dev/null
                yum install  nc -y > /dev/null
                echo -n "Enter the directory path to install spark : ";read a;
                mkdir $a;
                wget https://archive.apache.org/dist/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz
                mv  spark-2.3.0-bin-hadoop2.7.tgz $a
                cd $a;
                echo -e "export SPARK_HOME=$a/spark-2.3.0-bin-hadoop2.7" >> /root/.bash_profile
                source /root/.bash_profile
                tar zxvf spark-2.3.0-bin-hadoop2.7.tgz
                cd  $a/spark-2.3.0-bin-hadoop2.7/conf
                cp spark-env.sh.template  spark-env.sh
                cp slaves.template  slaves
                echo -n "Enter the spark Master IP address : ";read b;
                echo -e "export JAVA_HOME=$JAVA_HOME \nexport SPARK_WORKER_CORES=5  \nexport SPARK_MASTER_HOST=$b \nexport SPARK_DAEMON_MEMORY=2G \nexport SPARK_WORKER_MEMORY=2G \nexport SPARK_EXECUTOR_MEMORY=2G \nexport SPARK_MASTER_OPTS="-Dspark.deploy.defaultCores=1"" >> $a/spark-2.3.0-bin-hadoop2.7/conf/spark-env.sh
                sed -i '/localhost/s/^/#/g' $a/spark-2.3.0-bin-hadoop2.7/conf/slaves
                echo -e "\nroot@$b" >> $a/spark-2.3.0-bin-hadoop2.7/conf/slaves
                echo -e "spark Defined port is allowed at firewall 8080"

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
                        echo -e "changing port number "

                        echo -e "SPARK_MASTER_WEBUI_PORT=$c" >> $a/spark-2.3.0-bin-hadoop2.7/conf/spark-env.sh

                        cd $a/spark-2.3.0-bin-hadoop2.7/sbin
                        sh start-all.sh
                        firewall-cmd --zone=public --permanent --add-port=$c/tcp > /dev/null
                        firewall-cmd --zone=public --permanent --add-port=7077/tcp > /dev/null
                        firewall-cmd --zone=public --permanent --add-port=6066/tcp > /dev/null
                        firewall-cmd --zone=public --permanent --add-port=4044/tcp > /dev/null
                        firewall-cmd --reload > /dev/null


                        if ps aux | grep "spark.deploy.master" | grep -v "grep" | awk '{print $2}'> /dev/null
                                then
                                echo "spark master is started successfully"
                                else
                                echo "spark master is failed to start. See \"journalctl -xe\" for details";

                        fi
                        if ps aux | grep "spark.deploy.worker" | grep -v "grep" | awk '{print $2}'> /dev/null
                                then
                                echo "spark worker is started successfully"
                                else
                                echo "spark master is failed to start. See \"journalctl -xe\" for details";

                        fi

                        exit
                        else
                                        echo No
                fi


                cd $a/spark-2.3.0-bin-hadoop2.7/sbin
                sh start-all.sh
                firewall-cmd --zone=public --permanent --add-port=8080/tcp > /dev/null
                firewall-cmd --zone=public --permanent --add-port=7077/tcp > /dev/null
                firewall-cmd --zone=public --permanent --add-port=6066/tcp > /dev/null
                firewall-cmd --zone=public --permanent --add-port=4044/tcp > /dev/null
                firewall-cmd --reload > /dev/null


                if ps aux | grep "spark.deploy.master" | grep -v "grep" | awk '{print $2}'> /dev/null
                        then
                        echo "spark master is started successfully"
                        else
                        echo "zeppelin service is failed to start. See \"journalctl -xe\" for details";

                fi
                if ps aux | grep "spark.deploy.worker" | grep -v "grep" | awk '{print $2}'> /dev/null
                        then
                        echo "spark worker is started successfully"
                        else
                        echo "zeppelin service is failed to start. See \"journalctl -xe\" for details";

                fi

         else
         echo "No"
        fi
};

echo "$x"
if [ $x -ge 4096 ]
                then
                #echo "we can proceed to install"
                                rm -rf  /root/test.txt
                sparkinstall;

        else
                echo -n "memory is not sufficient to run ezflow application .If we install performance may be dedraded.Do you want to install  (y/n)? "
                old_stty_cfg=$(stty -g)
                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                if echo "$answer" | grep -iq "^y" ;then
                 echo "yes"
                                 rm -rf  /root/test.txt
                 sparkinstall;

                 else
                        echo "No"
                fi

   fi

};




x=" $(dmidecode --type memory |grep Size: |grep MB |xargs | awk '{print $2,$5,$8,$11,$14,$17,$20,$23,$26,$29,$32,$35,$38,$41,$44,$47,$50,$53,$56,$59}' | awk  '{ print $1+$2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20 }')"
echo "$x"
if [ $x -ge 4096 ]
                then
                #echo "we can proceed to install"

                scala;


        else
                echo -n "memory is not sufficient to run ezflow application .If we install performance may be dedraded.Do you want to install  (y/n)? "
                old_stty_cfg=$(stty -g)
                stty raw -echo ; answer=$(head -c 1) ; stty $old_stty_cfg # Careful playing with stty

                if echo "$answer" | grep -iq "^y" ;then
                 echo "yes"

                 scala;


                 else
                        echo "No"
                fi

   fi
